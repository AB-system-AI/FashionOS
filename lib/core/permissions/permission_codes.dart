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
