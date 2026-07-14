import 'package:uuid/uuid.dart';

import 'package:fashion_pos_enterprise/core/business/domain/enums/business_enums.dart';
import 'package:fashion_pos_enterprise/core/business/engines/notification_engine.dart';
import 'package:fashion_pos_enterprise/core/business/engines/workflow/approval_engine.dart';
import 'package:fashion_pos_enterprise/core/business/engines/workflow_engine.dart';
import 'package:fashion_pos_enterprise/core/errors/failure.dart';
import 'package:fashion_pos_enterprise/core/infrastructure/models/sync_enums.dart';
import 'package:fashion_pos_enterprise/core/infrastructure/pagination/paginated_result.dart';
import 'package:fashion_pos_enterprise/core/infrastructure/repository/repository_query.dart';
import 'package:fashion_pos_enterprise/core/permissions/permission_codes.dart';
import 'package:fashion_pos_enterprise/core/permissions/permission_engine.dart';
import 'package:fashion_pos_enterprise/core/result/result.dart';
import 'package:fashion_pos_enterprise/features/auth/domain/entities/auth_user.dart';
import 'package:fashion_pos_enterprise/features/workflow/domain/entities/approval.dart';
import 'package:fashion_pos_enterprise/features/workflow/domain/entities/approval_template.dart';
import 'package:fashion_pos_enterprise/features/workflow/domain/entities/notification.dart';
import 'package:fashion_pos_enterprise/features/workflow/domain/entities/workflow_instance.dart';
import 'package:fashion_pos_enterprise/features/workflow/domain/enums/workflow_enums.dart';
import 'package:fashion_pos_enterprise/features/workflow/domain/repositories/workflow_repositories.dart';

const _uuid = Uuid();

class WorkflowDashboardMetrics {
  const WorkflowDashboardMetrics({
    required this.activeDefinitions,
    required this.activeInstances,
    required this.pendingApprovals,
  });

  final int activeDefinitions;
  final int activeInstances;
  final int pendingApprovals;
}

class WorkflowAdminService {
  WorkflowAdminService({
    required TenantWorkflowDefinitionRepository definitions,
    required TenantWorkflowInstanceRepository instances,
    required ApprovalRequestRepository approvals,
    required WorkflowEngine workflowEngine,
    required PermissionEngine permissions,
  })  : _definitions = definitions,
        _instances = instances,
        _approvals = approvals,
        _workflowEngine = workflowEngine,
        _permissions = permissions;

  final TenantWorkflowDefinitionRepository _definitions;
  final TenantWorkflowInstanceRepository _instances;
  final ApprovalRequestRepository _approvals;
  final WorkflowEngine _workflowEngine;
  final PermissionEngine _permissions;

  Future<Result<WorkflowDashboardMetrics>> loadDashboard(AuthUser user) async {
    try {
      _permissions.require(user, WorkflowAdminPermissions.admin);
    } on PermissionDeniedException catch (e) {
      return Error(ValidationFailure(message: e.toString(), code: 'permission_denied'));
    }
    final tenantId = user.tenantId!;
    final defs = await _definitions.listActive(tenantId);
    final inst = await _instances.listActive(tenantId);
    final pending = await _approvals.listPending(tenantId);
    return Success(WorkflowDashboardMetrics(
      activeDefinitions: defs.length,
      activeInstances: inst.length,
      pendingApprovals: pending.length,
    ));
  }

  Future<Result<PaginatedResult<TenantWorkflowDefinition>>> listDefinitions(AuthUser user, {int page = 1}) async {
    try {
      _permissions.require(user, WorkflowAdminPermissions.admin);
    } on PermissionDeniedException catch (e) {
      return Error(ValidationFailure(message: e.toString(), code: 'permission_denied'));
    }
    final pageResult = await _definitions.getPage(RepositoryQuery(tenantId: user.tenantId!, page: page, pageSize: 50));
    return Success(pageResult);
  }

  WorkflowEngine get workflowEngine => _workflowEngine;
}

class ApprovalService {
  ApprovalService({
    required ApprovalTemplateRepository templates,
    required ApprovalMatrixRepository matrices,
    required ApprovalRequestRepository requests,
    required ApprovalHistoryRepository history,
    required ApprovalDelegationRepository delegations,
    required ApprovalEngine approvalEngine,
    required PermissionEngine permissions,
  })  : _templates = templates,
        _matrices = matrices,
        _requests = requests,
        _history = history,
        _delegations = delegations,
        _engine = approvalEngine,
        _permissions = permissions;

  final ApprovalTemplateRepository _templates;
  final ApprovalMatrixRepository _matrices;
  final ApprovalRequestRepository _requests;
  final ApprovalHistoryRepository _history;
  final ApprovalDelegationRepository _delegations;
  final ApprovalEngine _engine;
  final PermissionEngine _permissions;

  Future<Result<List<ApprovalRequest>>> listPending(AuthUser user) async {
    try {
      _permissions.require(user, ApprovalPermissions.view);
    } on PermissionDeniedException catch (e) {
      return Error(ValidationFailure(message: e.toString(), code: 'permission_denied'));
    }
    final items = await _requests.listPending(user.tenantId!, assignedTo: user.userId);
    return Success(items);
  }

  Future<Result<ApprovalRequest>> approve({
    required AuthUser user,
    required String requestId,
    required String actorRole,
    String? comment,
  }) async {
    try {
      _permissions.require(user, ApprovalPermissions.manage);
    } on PermissionDeniedException catch (e) {
      return Error(ValidationFailure(message: e.toString(), code: 'permission_denied'));
    }
    final request = await _requests.getById(requestId);
    if (request == null || request.tenantId != user.tenantId) {
      return const Error(ValidationFailure(message: 'Request not found', code: 'not_found'));
    }
    if (!request.isPending) {
      return const Error(ValidationFailure(message: 'Request is not pending', code: 'invalid_state'));
    }

    final matrixRows = await _loadMatrixRows(request);
    final resolved = _engine.resolveMatrix(matrix: matrixRows, amount: request.amount, entityType: request.targetEntityType);
    if (!_engine.canActorApprove(resolved: resolved, currentStepIndex: request.currentStepIndex, actorRole: actorRole)) {
      return const Error(ValidationFailure(message: 'Actor cannot approve this step', code: 'forbidden'));
    }

    final now = DateTime.now().toUtc();
    final isLastStep = request.currentStepIndex + 1 >= resolved.rows.length;
    final updated = request.copyWith(
      status: isLastStep ? ApprovalRequestStatus.approved : ApprovalRequestStatus.pending,
      currentStepIndex: isLastStep ? request.currentStepIndex : request.currentStepIndex + 1,
      resolvedAt: isLastStep ? now : null,
      updatedAt: now,
      isDirty: true,
      syncStatus: LocalSyncStatus.pending,
    );
    await _requests.update(updated);

    final entry = _engine.recordHistory(
      requestId: requestId,
      actorId: user.userId,
      decision: ApprovalDecision.approved,
      comment: comment,
      fromRole: actorRole,
    );
    await _saveHistory(user.tenantId!, entry);

    return Success(updated);
  }

  Future<Result<ApprovalRequest>> reject({
    required AuthUser user,
    required String requestId,
    String? comment,
  }) async {
    try {
      _permissions.require(user, ApprovalPermissions.manage);
    } on PermissionDeniedException catch (e) {
      return Error(ValidationFailure(message: e.toString(), code: 'permission_denied'));
    }
    final request = await _requests.getById(requestId);
    if (request == null || request.tenantId != user.tenantId) {
      return const Error(ValidationFailure(message: 'Request not found', code: 'not_found'));
    }
    final now = DateTime.now().toUtc();
    final updated = request.copyWith(
      status: ApprovalRequestStatus.rejected,
      comment: comment,
      resolvedAt: now,
      updatedAt: now,
      isDirty: true,
      syncStatus: LocalSyncStatus.pending,
    );
    await _requests.update(updated);
    await _saveHistory(
      user.tenantId!,
      _engine.recordHistory(requestId: requestId, actorId: user.userId, decision: ApprovalDecision.rejected, comment: comment),
    );
    return Success(updated);
  }

  Future<List<ApprovalMatrixRow>> _loadMatrixRows(ApprovalRequest request) async {
    final rows = await _matrices.listByTemplate(request.tenantId, request.templateId);
    return rows
        .map((m) => ApprovalMatrixRow(
              stepOrder: m.stepOrder,
              requiredRole: m.requiredRole,
              minAmount: m.minAmount,
              maxAmount: m.maxAmount,
              isOptional: m.isOptional,
            ))
        .toList();
  }

  Future<void> _saveHistory(String tenantId, ApprovalHistoryEntry entry) async {
    final now = DateTime.now().toUtc();
    await _history.create(ApprovalHistory(
      id: _uuid.v4(),
      tenantId: tenantId,
      requestId: entry.requestId,
      actorId: entry.actorId,
      decision: entry.decision.name,
      occurredAt: entry.occurredAt,
      comment: entry.comment,
      fromRole: entry.fromRole,
      toUserId: entry.toUserId,
      version: 1,
      createdAt: now,
      updatedAt: now,
      syncStatus: LocalSyncStatus.pending,
      isDirty: true,
    ));
  }
}

class NotificationCenterService {
  NotificationCenterService({
    required NotificationCenterRepository repository,
    required NotificationEngine notificationEngine,
    required PermissionEngine permissions,
  })  : _repository = repository,
        _notificationEngine = notificationEngine,
        _permissions = permissions;

  final NotificationCenterRepository _repository;
  final NotificationEngine _notificationEngine;
  final PermissionEngine _permissions;

  Future<Result<List<NotificationCenterItem>>> listUnread(AuthUser user) async {
    try {
      _permissions.require(user, NotificationCenterPermissions.view);
    } on PermissionDeniedException catch (e) {
      return Error(ValidationFailure(message: e.toString(), code: 'permission_denied'));
    }
    final items = await _repository.listUnread(user.tenantId!, user.userId);
    return Success(items);
  }

  Future<Result<int>> countUnread(AuthUser user) async {
    try {
      _permissions.require(user, NotificationCenterPermissions.view);
    } on PermissionDeniedException catch (e) {
      return Error(ValidationFailure(message: e.toString(), code: 'permission_denied'));
    }
    final count = await _repository.countUnread(user.tenantId!, user.userId);
    return Success(count);
  }

  Future<Result<NotificationCenterItem>> markRead(AuthUser user, String itemId) async {
    try {
      _permissions.require(user, NotificationCenterPermissions.manage);
    } on PermissionDeniedException catch (e) {
      return Error(ValidationFailure(message: e.toString(), code: 'permission_denied'));
    }
    final item = await _repository.getById(itemId);
    if (item == null || item.tenantId != user.tenantId) {
      return const Error(ValidationFailure(message: 'Notification not found', code: 'not_found'));
    }
    final now = DateTime.now().toUtc();
    final updated = item.copyWith(
      status: NotificationItemStatus.read,
      readAt: now,
      updatedAt: now,
      isDirty: true,
      syncStatus: LocalSyncStatus.pending,
    );
    await _repository.update(updated);
    return Success(updated);
  }

  Future<void> dispatchInApp({
    required String tenantId,
    required String recipientId,
    required String title,
    required String body,
    Map<String, dynamic> data = const {},
  }) async {
    await _notificationEngine.send(
      NotificationMessage(
        channel: NotificationChannel.inApp,
        title: title,
        body: body,
        recipientId: recipientId,
        data: data,
      ),
    );
    final now = DateTime.now().toUtc();
    await _repository.create(NotificationCenterItem(
      id: _uuid.v4(),
      tenantId: tenantId,
      recipientId: recipientId,
      title: title,
      body: body,
      data: data,
      version: 1,
      createdAt: now,
      updatedAt: now,
      syncStatus: LocalSyncStatus.pending,
      isDirty: true,
    ));
  }
}

class ReminderSchedulerService {
  ReminderSchedulerService({
    required ReminderRuleRepository rules,
    required ApprovalRequestRepository requests,
    required NotificationCenterService notificationCenter,
    required PermissionEngine permissions,
  })  : _rules = rules,
        _requests = requests,
        _notificationCenter = notificationCenter,
        _permissions = permissions;

  final ReminderRuleRepository _rules;
  final ApprovalRequestRepository _requests;
  final NotificationCenterService _notificationCenter;
  final PermissionEngine _permissions;

  Future<Result<int>> processDueReminders(AuthUser user) async {
    try {
      _permissions.require(user, WorkflowAdminPermissions.admin);
    } on PermissionDeniedException catch (e) {
      return Error(ValidationFailure(message: e.toString(), code: 'permission_denied'));
    }
    final tenantId = user.tenantId!;
    final rules = await _rules.listActive(tenantId);
    final pending = await _requests.listPending(tenantId);
    var sent = 0;
    final now = DateTime.now().toUtc();
    for (final request in pending) {
      for (final rule in rules) {
        if (rule.targetEntityType != null && rule.targetEntityType != request.targetEntityType) continue;
        final hoursSince = now.difference(request.createdAt).inHours;
        if (hoursSince >= rule.intervalHours && request.assignedTo != null) {
          await _notificationCenter.dispatchInApp(
            tenantId: tenantId,
            recipientId: request.assignedTo!,
            title: 'Approval reminder',
            body: 'Pending approval for ${request.targetEntityType ?? 'item'}',
            data: {'request_id': request.id},
          );
          sent++;
        }
      }
    }
    return Success(sent);
  }
}

class EscalationService {
  EscalationService({
    required EscalationRuleRepository rules,
    required ApprovalRequestRepository requests,
    required ApprovalEngine approvalEngine,
    required NotificationCenterService notificationCenter,
    required PermissionEngine permissions,
  })  : _rules = rules,
        _requests = requests,
        _engine = approvalEngine,
        _notificationCenter = notificationCenter,
        _permissions = permissions;

  final EscalationRuleRepository _rules;
  final ApprovalRequestRepository _requests;
  final ApprovalEngine _engine;
  final NotificationCenterService _notificationCenter;
  final PermissionEngine _permissions;

  Future<Result<int>> processEscalations(AuthUser user) async {
    try {
      _permissions.require(user, WorkflowAdminPermissions.admin);
    } on PermissionDeniedException catch (e) {
      return Error(ValidationFailure(message: e.toString(), code: 'permission_denied'));
    }
    final tenantId = user.tenantId!;
    final rules = await _rules.listActive(tenantId);
    final pending = await _requests.listPending(tenantId);
    var escalated = 0;
    final now = DateTime.now().toUtc();
    for (final request in pending) {
      for (final rule in rules) {
        if (rule.targetEntityType != null && rule.targetEntityType != request.targetEntityType) continue;
        final evaluation = _engine.evaluateEscalation(
          requestedAt: request.createdAt,
          timeout: Duration(hours: rule.timeoutHours),
          currentRole: null,
          escalateToRole: rule.escalateToRole,
          now: now,
        );
        if (!evaluation.shouldEscalate) continue;
        final updated = request.copyWith(
          status: ApprovalRequestStatus.escalated,
          updatedAt: now,
          isDirty: true,
          syncStatus: LocalSyncStatus.pending,
        );
        await _requests.update(updated);
        if (request.assignedTo != null) {
          await _notificationCenter.dispatchInApp(
            tenantId: tenantId,
            recipientId: request.assignedTo!,
            title: 'Approval escalated',
            body: evaluation.reason ?? 'Approval escalated',
            data: {'request_id': request.id},
          );
        }
        escalated++;
      }
    }
    return Success(escalated);
  }
}
