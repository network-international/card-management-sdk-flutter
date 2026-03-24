import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:card_management_sdk/card_management_sdk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelCardManagementSdk platform = MethodChannelCardManagementSdk();
  const MethodChannel channel = MethodChannel('card_management_sdk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'initialize':
              return null;
            case 'getCardDetails':
              return {'clearPan': '1234567890123456', 'maskedPan': '****3456'};
            case 'setPin':
            case 'verifyPin':
            case 'changePin':
              return {'status': 'success'};
            case 'getPin':
              return '1234';
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('initialize completes without error', () async {
    await expectLater(
      platform.initialize(
        token: 'test-token',
        rootUrl: 'https://example.com',
        bankCode: 'BANK01',
        cardIdentifierId: 'card-id',
        cardIdentifierType: 'EXID',
      ),
      completes,
    );
  });

  test('getCardDetails returns map', () async {
    final result = await platform.getCardDetails();
    expect(result, isNotNull);
    expect(result!['clearPan'], '1234567890123456');
  });

  test('setPin returns success status', () async {
    final result = await platform.setPin('1234');
    expect(result, isNotNull);
    expect(result!['status'], 'success');
  });

  test('verifyPin returns success status', () async {
    final result = await platform.verifyPin('1234');
    expect(result, isNotNull);
    expect(result!['status'], 'success');
  });

  test('changePin returns success status', () async {
    final result = await platform.changePin('1234', '5678');
    expect(result, isNotNull);
    expect(result!['status'], 'success');
  });

  test('getPin returns pin string', () async {
    final result = await platform.getPin();
    expect(result, '1234');
  });
}

