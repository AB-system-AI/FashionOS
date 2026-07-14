/// Canonical permission codes — format: `{module}.{action}`.
abstract final class ProductPermissions {
  static const read = 'product.read';
  static const create = 'product.create';
  static const update = 'product.update';
  static const delete = 'product.delete';
  static const import = 'product.import';
  static const export = 'product.export';
  static const archive = 'product.archive';
  static const bulk = 'product.bulk';
  static const variantManage = 'product.variant.manage';
}

abstract final class CategoryPermissions {
  static const read = 'category.read';
  static const create = 'category.create';
  static const update = 'category.update';
  static const delete = 'category.delete';
  static const manage = 'category.manage';
}

abstract final class BrandPermissions {
  static const read = 'brand.read';
  static const create = 'brand.create';
  static const update = 'brand.update';
  static const delete = 'brand.delete';
  static const manage = 'brand.manage';
}

abstract final class WarehousePermissions {
  static const view = 'warehouse.view';
  static const create = 'warehouse.create';
  static const update = 'warehouse.update';
  static const delete = 'warehouse.delete';
}

abstract final class InventoryPermissions {
  static const read = 'inventory.read';
  static const adjust = 'inventory.adjust';
  static const movement = 'inventory.movement';
  static const transferCreate = 'inventory.transfer.create';
  static const transferApprove = 'inventory.transfer.approve';
  static const transferReceive = 'inventory.transfer.receive';
  static const count = 'inventory.count';
}

abstract final class SupplierPermissions {
  static const view = 'supplier.view';
  static const create = 'supplier.create';
  static const update = 'supplier.update';
  static const delete = 'supplier.delete';
}

abstract final class PurchasePermissions {
  static const view = 'purchase.view';
  static const create = 'purchase.create';
  static const update = 'purchase.update';
  static const approve = 'purchase.approve';
  static const send = 'purchase.send';
  static const receive = 'purchase.receive';
  static const close = 'purchase.close';
  static const cancel = 'purchase.cancel';
  static const payment = 'purchase.payment';
  static const returnCreate = 'purchase.return.create';
  static const returnApprove = 'purchase.return.approve';
  static const report = 'purchase.report';
}

abstract final class CustomerPermissions {
  static const view = 'customer.view';
  static const create = 'customer.create';
  static const update = 'customer.update';
  static const delete = 'customer.delete';
}

abstract final class LoyaltyPermissions {
  static const manage = 'loyalty.manage';
}

abstract final class WalletPermissions {
  static const manage = 'wallet.manage';
}

abstract final class CreditPermissions {
  static const manage = 'credit.manage';
}

abstract final class SalePermissions {
  static const view = 'sale.view';
  static const create = 'sale.create';
  static const update = 'sale.update';
  static const cancel = 'sale.cancel';
  static const refund = 'sale.refund';
  static const exchange = 'sale.exchange';
  static const discount = 'sale.discount';
  static const overridePrice = 'sale.override_price';
  static const print = 'sale.print';
  static const cash = 'sale.cash';
  static const closeSession = 'sale.close_session';
  static const payment = 'sale.payment';
}

abstract final class CouponPermissions {
  static const manage = 'coupon.manage';
}

abstract final class ReceiptPermissions {
  static const reprint = 'receipt.reprint';
}

abstract final class LayawayPermissions {
  static const manage = 'layaway.manage';
}

abstract final class GiftReceiptPermissions {
  static const create = 'giftreceipt.create';
}

abstract final class AccountingPermissions {
  static const view = 'accounting.view';
  static const manage = 'accounting.manage';
}

abstract final class JournalPermissions {
  static const create = 'journal.create';
  static const post = 'journal.post';
  static const reverse = 'journal.reverse';
}

abstract final class LedgerPermissions {
  static const view = 'ledger.view';
}

abstract final class FiscalPermissions {
  static const close = 'fiscal.close';
}

abstract final class BankPermissions {
  static const manage = 'bank.manage';
  static const reconcile = 'bank.reconcile';
}

abstract final class FinancialReportPermissions {
  static const financial = 'reports.financial';
  static const tax = 'reports.tax';
}

abstract final class HrPermissions {
  static const view = 'hr.view';
  static const manage = 'hr.manage';
}

abstract final class EmployeePermissions {
  static const manage = 'employee.manage';
}

abstract final class AttendancePermissions {
  static const manage = 'attendance.manage';
}

abstract final class LeavePermissions {
  static const manage = 'leave.manage';
}

abstract final class PayrollPermissions {
  static const manage = 'payroll.manage';
  static const approve = 'payroll.approve';
  static const view = 'payroll.view';
}

abstract final class PerformancePermissions {
  static const manage = 'performance.manage';
}

abstract final class CommissionPermissions {
  static const manage = 'commission.manage';
}

abstract final class ManufacturingPermissions {
  static const view = 'manufacturing.view';
  static const manage = 'manufacturing.manage';
}

abstract final class BomPermissions {
  static const manage = 'bom.manage';
}

abstract final class ProductionPermissions {
  static const create = 'production.create';
  static const release = 'production.release';
  static const complete = 'production.complete';
}

abstract final class QualityPermissions {
  static const manage = 'quality.manage';
}

abstract final class PlanningPermissions {
  static const manage = 'planning.manage';
}

abstract final class MaintenancePermissions {
  static const manage = 'maintenance.manage';
}

abstract final class AnalyticsPermissions {
  static const view = 'analytics.view';
  static const manage = 'analytics.manage';
}

abstract final class DashboardPermissions {
  static const manage = 'dashboard.manage';
}

abstract final class ReportPermissions {
  static const view = 'reports.view';
  static const create = 'reports.create';
  static const export = 'reports.export';
  static const schedule = 'reports.schedule';
}

abstract final class KpiPermissions {
  static const view = 'kpi.view';
}

abstract final class ExecutiveDashboardPermissions {
  static const view = 'executive.dashboard';
}

abstract final class SalesOmsPermissions {
  static const view = 'sales.view';
  static const manage = 'sales.manage';
}

abstract final class QuotationPermissions {
  static const create = 'quotation.create';
  static const approve = 'quotation.approve';
}

abstract final class SalesApprovalPermissions {
  static const approve = 'sales.approve';
}

abstract final class ShipmentPermissions {
  static const manage = 'shipment.manage';
}

abstract final class DeliveryPermissions {
  static const manage = 'delivery.manage';
}

abstract final class SalesInvoicePermissions {
  static const create = 'invoice.create';
}

abstract final class SalesReturnPermissions {
  static const manage = 'return.manage';
}

abstract final class SalesExchangePermissions {
  static const manage = 'exchange.manage';
}
