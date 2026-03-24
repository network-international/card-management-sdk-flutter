
import 'card_management_sdk_platform_interface.dart';

class CardManagementSdk {
  Future<String?> getPlatformVersion() {
    return CardManagementSdkPlatform.instance.getPlatformVersion();
  }
}
