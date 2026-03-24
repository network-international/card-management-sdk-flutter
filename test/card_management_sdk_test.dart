import 'package:flutter_test/flutter_test.dart';
import 'package:card_management_sdk/card_management_sdk.dart';
import 'package:card_management_sdk/card_management_sdk_platform_interface.dart';
import 'package:card_management_sdk/card_management_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCardManagementSdkPlatform
    with MockPlatformInterfaceMixin
    implements CardManagementSdkPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CardManagementSdkPlatform initialPlatform = CardManagementSdkPlatform.instance;

  test('$MethodChannelCardManagementSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCardManagementSdk>());
  });

  test('getPlatformVersion', () async {
    CardManagementSdk cardManagementSdkPlugin = CardManagementSdk();
    MockCardManagementSdkPlatform fakePlatform = MockCardManagementSdkPlatform();
    CardManagementSdkPlatform.instance = fakePlatform;

    expect(await cardManagementSdkPlugin.getPlatformVersion(), '42');
  });
}
