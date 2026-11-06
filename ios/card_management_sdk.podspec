#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint card_management_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'card_management_sdk'
  s.version          = '0.2.0'
  s.summary          = 'SDKs to help card issuers to consume our APIs from Flutter applications.'
  s.description      = 'SDKs to help card issuers to consume our APIs from Flutter applications.'
  s.homepage         = 'https://developer.network.global'
  s.license          = { :file => '../LICENSE' }
  s.author    = 'Network International'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '15.0'
  s.swift_version = '5.0'

  # Core is SPM/binary-only (no CocoaPods product). Fetch XCFramework from the public Release.
  core_version = '0.1.1'
  s.prepare_command = <<-CMD
    set -euo pipefail
    VERSION="#{core_version}"
    ZIP="NICardManagementSDKCore.xcframework.zip"
    URL="https://github.com/network-international/card-management-sdk-core/releases/download/${VERSION}/${ZIP}"
    mkdir -p Frameworks
    if [ ! -d "Frameworks/NICardManagementSDKCore.xcframework" ]; then
      curl -fsSL -o "Frameworks/${ZIP}" "${URL}"
      unzip -qo "Frameworks/${ZIP}" -d Frameworks
      rm -f "Frameworks/${ZIP}"
    fi
  CMD
  s.vendored_frameworks = 'Frameworks/NICardManagementSDKCore.xcframework'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.resource_bundles = {'card_management_sdk_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
