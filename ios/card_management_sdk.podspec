#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint card_management_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'card_management_sdk'
  s.version          = '1.0.0'
  s.summary          = 'SDKs to help card issuers to consume our APIs from Flutter applications.'
  s.description      = 'SDKs to help card issuers to consume our APIs from Flutter applications.'
  s.homepage         = 'https://developer.network.global'
  s.license          = { :file => '../LICENSE' }
  s.author    = 'Network International'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'NICardManagementSDK', '2.1.4'
  s.platform = :ios, '15.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  s.resource_bundles = {'card_management_sdk_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
