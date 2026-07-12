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
