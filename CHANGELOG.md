## 0.2.0

* Native stack uses **Core only** (`ae.network:ni-card-management-sdk-core:0.1.1` / XCFramework 0.1.1). Removed dependency on Android/iOS UI SDKs — Flutter owns UI.

## 0.1.6

* Remove obsolete data from example

## 0.1.5

* Updated dependencies, example, readme

## 0.1.5

* Updated dependencies, example, readme

## 0.1.5

* Updated dependencies, example, readme

## 0.1.5

* Updated dependencies, example, readme

## 0.1.4

* Updated NICardManagementSDK to version 2.1.7

## 0.1.3

* Fixed Android plugin integration to use the native SDK suspend APIs correctly.
* Updated Android PIN retrieval to call the native `viewPin` API.

## 0.1.2

* Fixed rootUrl example in README: corrected path from `/api/v2/sdk/v2` to `/sdk/v2`.
* Added pub.dev badge and link to README.
* Updated example app to use published package version instead of local path dependency.

## 0.1.1

* Fixed iOS deployment target documentation: corrected minimum to 15.0 (was incorrectly stated as 12.0).

## 0.1.0

* First public release of the Flutter plugin.
* Added SDK initialization support for Android and iOS.
* Added card details retrieval.
* Added PIN operations: set PIN, verify PIN, change PIN, and get PIN.
* Added integration guidance in the README, including Android ProGuard / R8 notes.

## 0.0.1

* Initial internal project scaffold.
