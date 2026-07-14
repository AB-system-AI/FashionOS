/// Workflow module status values.
enum WorkflowDefinitionStatus {
  draft('draft'),
  active('active'),
  archived('archived');

  const WorkflowDefinitionStatus(this.value);
  final String value;

  static WorkflowDefinitionStatus fromValue(String? v) =>
      WorkflowDefinitionStatus.values.firstWhere((e) => e.value == v, orElse: () => WorkflowDefinitionStatus.draft);
}

enum WorkflowInstanceStatus {
  pending('pending'),
  inProgress('in_progress'),
  completed('completed'),
  rejected('rejected'),
  cancelled('cancelled');

  const WorkflowInstanceStatus(this.value);
  final String value;

  static WorkflowInstanceStatus fromValue(String? v) =>
      WorkflowInstanceStatus.values.firstWhere((e) => e.value == v, orElse: () => WorkflowInstanceStatus.pending);
}

enum ApprovalRequestStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  delegated('delegated'),
  escalated('escalated'),
  expired('expired');

  const ApprovalRequestStatus(this.value);
  final String value;

  static ApprovalRequestStatus fromValue(String? v) =>
      ApprovalRequestStatus.values.firstWhere((e) => e.value == v, orElse: () => ApprovalRequestStatus.pending);
}

enum NotificationItemStatus {
  unread('unread'),
  read('read'),
  archived('archived');

  const NotificationItemStatus(this.value);
  final String value;

  static NotificationItemStatus fromValue(String? v) =>
      NotificationItemStatus.values.firstWhere((e) => e.value == v, orElse: () => NotificationItemStatus.unread);
}

enum NotificationPriority {
  low('low'),
  normal('normal'),
  high('high'),
  urgent('urgent');

  const NotificationPriority(this.value);
  final String value;

  static NotificationPriority fromValue(String? v) =>
      NotificationPriority.values.firstWhere((e) => e.value == v, orElse: () => NotificationPriority.normal);
}

enum ReminderScheduleType {
  once('once'),
  interval('interval'),
  cron('cron');

  const ReminderScheduleType(this.value);
  final String value;

  static ReminderScheduleType fromValue(String? v) =>
      ReminderScheduleType.values.firstWhere((e) => e.value == v, orElse: () => ReminderScheduleType.once);
}

enum EscalationTriggerType {
  timeout('timeout'),
  noResponse('no_response'),
  threshold('threshold');

  const EscalationTriggerType(this.value);
  final String value;

  static EscalationTriggerType fromValue(String? v) =>
      EscalationTriggerType.values.firstWhere((e) => e.value == v, orElse: () => EscalationTriggerType.timeout);
}
