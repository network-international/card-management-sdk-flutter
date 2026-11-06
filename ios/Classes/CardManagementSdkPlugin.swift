import Flutter
import UIKit
import NICardManagementSDKCore

public class CardManagementSdkPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "card_management_sdk",
            binaryMessenger: registrar.messenger()
        )
        let instance = CardManagementSdkPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "initialize":
            handleInitialize(call, result: result)
        case "getCardDetails":
            handleGetCardDetails(result: result)
        case "setPin":
            handleSetPin(call, result: result)
        case "verifyPin":
            handleVerifyPin(call, result: result)
        case "changePin":
            handleChangePin(call, result: result)
        case "getPin":
            handleGetPin(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Handlers

    private func handleInitialize(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let args = call.arguments as? [String: Any],
            let token = args["token"] as? String,
            let rootUrl = args["rootUrl"] as? String,
            let bankCode = args["bankCode"] as? String,
            let cardIdentifierId = args["cardIdentifierId"] as? String,
            let cardIdentifierType = args["cardIdentifierType"] as? String
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing required arguments", details: nil))
            return
        }
        let debugLogToConsole = args["debugLogToConsole"] as? Bool ?? false
        let extraNetworkHeaders = args["extraNetworkHeaders"] as? [String: String]
        NICardManagementConfig.shared.initialize(
            token: token,
            rootUrl: rootUrl,
            bankCode: bankCode,
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            debugLogToConsole: debugLogToConsole,
            extraNetworkHeaders: extraNetworkHeaders
        )
        result(nil)
    }

    private func handleGetCardDetails(result: @escaping FlutterResult) {
        guard let api = NICardManagementConfig.shared.api else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "SDK not initialized", details: nil))
            return
        }
        api.getCardDetails { cardDetails, errorResponse, _ in
            if let error = errorResponse {
                result(FlutterError(code: error.errorCode, message: error.errorMessage, details: nil))
                return
            }
            guard let details = cardDetails else {
                result(FlutterError(code: "INVALID_ARGS", message: "Missing card details in response", details: nil))
                return
            }
            let map: [String: Any?] = [
                "clearPan": details.clearPan,
                "maskedPan": details.maskedPan,
                "expiry": details.expiry,
                "clearCVV2": details.clearCVV2,
                "cardholderName": details.cardholderName,
            ]
            result(map.compactMapValues { $0 })
        }
    }

    private func handleSetPin(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let args = call.arguments as? [String: Any],
            let pin = args["pin"] as? String
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing pin argument", details: nil))
            return
        }
        guard let api = NICardManagementConfig.shared.api else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "SDK not initialized", details: nil))
            return
        }
        api.setPin(pin: pin) { successResponse, errorResponse, _ in
            if let error = errorResponse {
                result(FlutterError(code: error.errorCode, message: error.errorMessage, details: nil))
                return
            }
            result(["status": successResponse?.message ?? "success"])
        }
    }

    private func handleVerifyPin(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let args = call.arguments as? [String: Any],
            let pin = args["pin"] as? String
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing pin argument", details: nil))
            return
        }
        guard let api = NICardManagementConfig.shared.api else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "SDK not initialized", details: nil))
            return
        }
        api.verifyPin(pin: pin) { successResponse, errorResponse, _ in
            if let error = errorResponse {
                result(FlutterError(code: error.errorCode, message: error.errorMessage, details: nil))
                return
            }
            result(["status": successResponse?.message ?? "success"])
        }
    }

    private func handleChangePin(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard
            let args = call.arguments as? [String: Any],
            let oldPin = args["oldPin"] as? String,
            let newPin = args["newPin"] as? String
        else {
            result(FlutterError(code: "INVALID_ARGS", message: "Missing pin arguments", details: nil))
            return
        }
        guard let api = NICardManagementConfig.shared.api else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "SDK not initialized", details: nil))
            return
        }
        api.changePin(oldPin: oldPin, newPin: newPin) { successResponse, errorResponse, _ in
            if let error = errorResponse {
                result(FlutterError(code: error.errorCode, message: error.errorMessage, details: nil))
                return
            }
            result(["status": successResponse?.message ?? "success"])
        }
    }

    private func handleGetPin(result: @escaping FlutterResult) {
        guard let api = NICardManagementConfig.shared.api else {
            result(FlutterError(code: "NOT_INITIALIZED", message: "SDK not initialized", details: nil))
            return
        }
        api.getPin { viewPinResponse, errorResponse, _ in
            if let error = errorResponse {
                result(FlutterError(
                    code: error.errorCode,
                    message: error.errorMessage,
                    details: nil
                ))
                return
            }
            result(viewPinResponse)
        }
    }
}

