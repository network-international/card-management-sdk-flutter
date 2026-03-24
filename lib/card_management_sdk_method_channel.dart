import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'card_management_sdk_platform_interface.dart';

/// An implementation of [CardManagementSdkPlatform] that uses method channels.
class MethodChannelCardManagementSdk extends CardManagementSdkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('card_management_sdk');

  @override
  Future<void> initialize({
    required String token,
    required String rootUrl,
    required String bankCode,
    required String cardIdentifierId,
    required String cardIdentifierType,
    bool debugLogToConsole = false,
    Map<String, String>? extraNetworkHeaders,
  }) async {
    await methodChannel.invokeMethod<void>('initialize', {
      'token': token,
      'rootUrl': rootUrl,
      'bankCode': bankCode,
      'cardIdentifierId': cardIdentifierId,
      'cardIdentifierType': cardIdentifierType,
      'debugLogToConsole': debugLogToConsole,
      'extraNetworkHeaders': extraNetworkHeaders,
    });
  }

  @override
  Future<Map<String, dynamic>?> getCardDetails() async {
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'getCardDetails',
    );
    return result;
  }

  @override
  Future<Map<String, dynamic>?> setPin(String pin) async {
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'setPin',
      {'pin': pin},
    );
    return result;
  }

  @override
  Future<Map<String, dynamic>?> verifyPin(String pin) async {
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'verifyPin',
      {'pin': pin},
    );
    return result;
  }

  @override
  Future<Map<String, dynamic>?> changePin(
    String oldPin,
    String newPin,
  ) async {
    final result = await methodChannel.invokeMapMethod<String, dynamic>(
      'changePin',
      {'oldPin': oldPin, 'newPin': newPin},
    );
    return result;
  }

  @override
  Future<String?> getPin() async {
    final result = await methodChannel.invokeMethod<String>('getPin');
    return result;
  }
}

