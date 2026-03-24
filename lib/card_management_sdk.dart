
import 'card_management_sdk_platform_interface.dart';

class CardManagementSdk {
  Future<void> initialize({
    required String token,
    required String rootUrl,
    required String bankCode,
    required String cardIdentifierId,
    required String cardIdentifierType,
  }) {
    return CardManagementSdkPlatform.instance.initialize(
      token: token,
      rootUrl: rootUrl,
      bankCode: bankCode,
      cardIdentifierId: cardIdentifierId,
      cardIdentifierType: cardIdentifierType,
    );
  }

  Future<Map<String, dynamic>?> getCardDetails() {
    return CardManagementSdkPlatform.instance.getCardDetails();
  }

  Future<Map<String, dynamic>?> setPin(String pin) {
    return CardManagementSdkPlatform.instance.setPin(pin);
  }

  Future<Map<String, dynamic>?> verifyPin(String pin) {
    return CardManagementSdkPlatform.instance.verifyPin(pin);
  }

  Future<Map<String, dynamic>?> changePin(String oldPin, String newPin) {
    return CardManagementSdkPlatform.instance.changePin(oldPin, newPin);
  }

  Future<String?> getPin() {
    return CardManagementSdkPlatform.instance.getPin();
  }
}

