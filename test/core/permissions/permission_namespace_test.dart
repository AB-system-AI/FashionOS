import 'package:flutter_test/flutter_test.dart';

import 'package:fashion_pos_enterprise/core/permissions/permission_codes.dart';

void main() {
  test('maintenance permission codes are namespaced per module', () {
    expect(MaintenancePermissions.manage, 'manufacturing.maintenance.manage');
    expect(SystemMaintenancePermissions.manage, 'system.maintenance.manage');
    expect(AssetMaintenancePermissions.view, 'assets.maintenance.view');
    expect(AssetMaintenancePermissions.manage, 'assets.maintenance.manage');

    final codes = {
      MaintenancePermissions.manage,
      SystemMaintenancePermissions.manage,
      AssetMaintenancePermissions.view,
      AssetMaintenancePermissions.manage,
    };
    expect(codes.length, 4, reason: 'maintenance codes must not collide');
  });

  test('treasury bank and receipt codes are distinct from accounting and POS', () {
    expect(TreasuryBankPermissions.manage, 'treasury.bank.manage');
    expect(TreasuryReceiptPermissions.manage, 'treasury.receipt.manage');
    expect(BankPermissions.manage, 'bank.manage');
    expect(ReceiptPermissions.reprint, 'receipt.reprint');
    expect(ReceiptPermissions.manage, 'receipt.manage');

    expect(TreasuryBankPermissions.manage, isNot(BankPermissions.manage));
    expect(TreasuryReceiptPermissions.manage, isNot(ReceiptPermissions.manage));
  });
}
