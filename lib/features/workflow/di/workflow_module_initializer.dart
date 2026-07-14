import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fashion_pos_enterprise/core/di/enterprise_providers.dart';
import 'package:fashion_pos_enterprise/features/workflow/presentation/providers/workflow_providers.dart';

final workflowModuleInitializerProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final sync = ref.read(syncCoordinatorProvider);
    sync.registerProcessor(ref.read(wfDefinitionSyncProcessorProvider));
    sync.registerProcessor(ref.read(wfInstanceSyncProcessorProvider));
    sync.registerProcessor(ref.read(approvalTemplateSyncProcessorProvider));
    sync.registerProcessor(ref.read(approvalMatrixSyncProcessorProvider));
    sync.registerProcessor(ref.read(wfApprovalRequestSyncProcessorProvider));
    sync.registerProcessor(ref.read(wfApprovalHistorySyncProcessorProvider));
    sync.registerProcessor(ref.read(wfApprovalDelegationSyncProcessorProvider));
    sync.registerProcessor(ref.read(wfNotificationSyncProcessorProvider));
    sync.registerProcessor(ref.read(reminderRuleSyncProcessorProvider));
    sync.registerProcessor(ref.read(escalationRuleSyncProcessorProvider));
  };
});
