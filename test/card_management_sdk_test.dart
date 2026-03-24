import 'package:flutter_test/flutter_test.dart';
import 'package:card_management_sdk/card_management_sdk.dart';
import 'package:card_management_sdk/card_management_sdk_platform_interface.dart';
import 'package:card_management_sdk/card_management_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCardManagementSdkPlatform
    with MockPlatformInterfaceMixin
    implements CardManagementSdkPlatform {
  @override
  Future<void> initialize({
    required String token,
    required String rootUrl,
    required String bankCode,
    required String cardIdentifierId,
    required String cardIdentifierType,
  }) async {}

  @override
  Future<Map<String, dynamic>?> getCardDetails() async =>
      {'clearPan': '1234567890123456'};

  @override
  Future<Map<String, dynamic>?> setPin(String pin) async =>
      {'status': 'success'};

  @override
  Future<Map<String, dynamic>?> verifyPin(String pin) async =>
      {'status': 'success'};

  @override
  Future<Map<String, dynamic>?> changePin(
          String oldPin, String newPin) async =>
      {'status': 'success'};

  @override
  Future<String?> getPin() async => '1234';
}

void main() {
  final CardManagementSdkPlatform initialPlatform =
      CardManagementSdkPlatform.instance;

  test('$MethodChannelCardManagementSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCardManagementSdk>());
  });

  group('CardManagementSdk with mock platform', () {
    late CardManagementSdk sdk;
    late MockCardManagementSdkPlatform fakePlatform;

    setUp(() {
      sdk = CardManagementSdk();
      fakePlatform = MockCardManagementSdkPlatform();
      CardManagementSdkPlatform.instance = fakePlatform;
    });

    test('initialize completes', () async {
      await expectLater(
        sdk.initialize(
          token: 'tok',
          rootUrl: 'https://example.com',
          bankCode: 'BANK',
          cardIdentifierId: 'id',
          cardIdentifierType: 'EXID',
        ),
        completes,
      );
    });

    test('getCardDetails returns expected data', () async {
      final result = await sdk.getCardDetails();
      expect(result, isNotNull);
      expect(result!['clearPan'], '1234567890123456');
    });

    test('setPin returns success', () async {
      final result = await sdk.setPin('1234');
      expect(result!['status'], 'success');
    });

    test('verifyPin returns success', () async {
      final result = await sdk.verifyPin('1234');
      expect(result!['status'], 'success');
    });

    test('changePin returns success', () async {
      final result = await sdk.changePin('1234', '5678');
      expect(result!['status'], 'success');
    });

    test('getPin returns pin string', () async {
      final result = await sdk.getPin();
      expect(result, '1234');
    });
  });
}

