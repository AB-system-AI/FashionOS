import 'package:fashion_pos_enterprise/core/infrastructure/pagination/paginated_result.dart';
import 'package:fashion_pos_enterprise/core/infrastructure/repository/base_local_repository.dart';
import 'package:fashion_pos_enterprise/core/infrastructure/repository/repository_query.dart';
import 'package:fashion_pos_enterprise/features/workflow/domain/entities/approval.dart';
import 'package:fashion_pos_enterprise/features/workflow/domain/entities/approval_template.dart';
import 'package:fashion_pos_enterprise/features/workflow/domain/entities/notification.dart';
import 'package:fashion_pos_enterprise/features/workflow/domain/entities/workflow_instance.dart';

abstract class TenantWorkflowDefinitionRepository implements BaseLocalRepository<TenantWorkflowDefinition> {
  Future<List<TenantWorkflowDefinition>> listActive(String tenantId);
}

abstract class TenantWorkflowInstanceRepository implements BaseLocalRepository<TenantWorkflowInstance> {
  Future<List<TenantWorkflowInstance>> listActive(String tenantId);
  Future<TenantWorkflowInstance?> getByEntity(String tenantId, String entityId);
}

abstract class ApprovalTemplateRepository implements BaseLocalRepository<ApprovalTemplate> {
  Future<List<ApprovalTemplate>> listActive(String tenantId, {String? entityType});
}

abstract class ApprovalMatrixRepository implements BaseLocalRepository<ApprovalMatrix> {
  Future<List<ApprovalMatrix>> listByTemplate(String tenantId, String templateId);
}

abstract class ApprovalRequestRepository implements BaseLocalRepository<ApprovalRequest> {
  Future<List<ApprovalRequest>> listPending(String tenantId, {String? assignedTo});
  Future<PaginatedResult<ApprovalRequest>> listByStatus(String tenantId, String status, {int page = 1, int pageSize = 50});
}

abstract class ApprovalHistoryRepository implements BaseLocalRepository<ApprovalHistory> {
  Future<List<ApprovalHistory>> listByRequest(String tenantId, String requestId);
}

abstract class ApprovalDelegationRepository implements BaseLocalRepository<ApprovalDelegation> {
  Future<List<ApprovalDelegation>> listActive(String tenantId, {String? fromUserId});
}

abstract class NotificationCenterRepository implements BaseLocalRepository<NotificationCenterItem> {
  Future<List<NotificationCenterItem>> listUnread(String tenantId, String recipientId);
  Future<int> countUnread(String tenantId, String recipientId);
}

abstract class ReminderRuleRepository implements BaseLocalRepository<ReminderRule> {
  Future<List<ReminderRule>> listActive(String tenantId);
}

abstract class EscalationRuleRepository implements BaseLocalRepository<EscalationRule> {
  Future<List<EscalationRule>> listActive(String tenantId, {String? entityType});
}
