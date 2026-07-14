import 'package:flutter_test/flutter_test.dart';

import 'package:fashion_pos_enterprise/core/permissions/permission_codes.dart';

void main() {
  test('assets permission codes are stable', () {
    expect(AssetsPermissions.view, 'assets.view');
    expect(AssetsPermissions.manage, 'assets.manage');
    expect(AssetMaintenancePermissions.view, 'maintenance.view');
    expect(AssetMaintenancePermissions.manage, 'maintenance.manage');
    expect(DepreciationPermissions.manage, 'depreciation.manage');
    expect(DisposalPermissions.manage, 'disposal.manage');
  });
}
