package global.network.card_management_sdk

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** CardManagementSdkPlugin */
class CardManagementSdkPlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will handle communication between Flutter and native Android
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "card_management_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        when (call.method) {
            "initialize" -> handleInitialize(call, result)
            "getCardDetails" -> handleGetCardDetails(result)
            "setPin" -> handleSetPin(call, result)
            "verifyPin" -> handleVerifyPin(call, result)
            "changePin" -> handleChangePin(call, result)
            "getPin" -> handleGetPin(result)
            else -> result.notImplemented()
        }
    }

    // MARK: - Handlers

    private fun handleInitialize(call: MethodCall, result: Result) {
        try {
            val token = call.argument<String>("token")
            val rootUrl = call.argument<String>("rootUrl")
            val bankCode = call.argument<String>("bankCode")
            val cardIdentifierId = call.argument<String>("cardIdentifierId")
            val cardIdentifierType = call.argument<String>("cardIdentifierType")
            val debugLogToConsole = call.argument<Boolean>("debugLogToConsole") ?: false
            val extraNetworkHeaders = call.argument<Map<String, String>>("extraNetworkHeaders")

            if (token == null || rootUrl == null || bankCode == null ||
                cardIdentifierId == null || cardIdentifierType == null
            ) {
                result.error(
                    "INVALID_ARGS",
                    "Missing required arguments",
                    null
                )
                return
            }

            NICardManagementConfig.initialize(
                token = token,
                rootUrl = rootUrl,
                bankCode = bankCode,
                cardIdentifierId = cardIdentifierId,
                cardIdentifierType = cardIdentifierType,
                extraNetworkHeaders = extraNetworkHeaders
            )
            result.success(null)
        } catch (e: Exception) {
            result.error("INITIALIZE_ERROR", e.message, null)
        }
    }

    private fun handleGetCardDetails(result: Result) {
        try {
            val api = NICardManagementConfig.api
            if (api == null) {
                result.error("NOT_INITIALIZED", "SDK not initialized", null)
                return
            }

            api.getCardDetails { cardDetails, errorResponse ->
                if (errorResponse != null) {
                    result.error(
                        errorResponse.errorCode,
                        errorResponse.errorMessage,
                        null
                    )
                    return@getCardDetails
                }

                if (cardDetails == null) {
                    result.error("INVALID_RESPONSE", "Missing card details in response", null)
                    return@getCardDetails
                }

                val map = mapOf(
                    "clearPan" to cardDetails.clearPan,
                    "maskedPan" to cardDetails.maskedPan,
                    "expiry" to cardDetails.expiry,
                    "clearCVV2" to cardDetails.clearCVV2,
                    "cardholderName" to cardDetails.cardholderName
                )
                result.success(map)
            }
        } catch (e: Exception) {
            result.error("GET_CARD_DETAILS_ERROR", e.message, null)
        }
    }

    private fun handleSetPin(call: MethodCall, result: Result) {
        try {
            val pin = call.argument<String>("pin")
            if (pin == null) {
                result.error("INVALID_ARGS", "Missing pin argument", null)
                return
            }

            val api = NICardManagementConfig.api
            if (api == null) {
                result.error("NOT_INITIALIZED", "SDK not initialized", null)
                return
            }

            api.setPin(pin) { successResponse, errorResponse ->
                if (errorResponse != null) {
                    result.error(
                        errorResponse.errorCode,
                        errorResponse.errorMessage,
                        null
                    )
                    return@setPin
                }

                val map = mapOf(
                    "status" to (successResponse?.message ?: "success")
                )
                result.success(map)
            }
        } catch (e: Exception) {
            result.error("SET_PIN_ERROR", e.message, null)
        }
    }

    private fun handleVerifyPin(call: MethodCall, result: Result) {
        try {
            val pin = call.argument<String>("pin")
            if (pin == null) {
                result.error("INVALID_ARGS", "Missing pin argument", null)
                return
            }

            val api = NICardManagementConfig.api
            if (api == null) {
                result.error("NOT_INITIALIZED", "SDK not initialized", null)
                return
            }

            api.verifyPin(pin) { successResponse, errorResponse ->
                if (errorResponse != null) {
                    result.error(
                        errorResponse.errorCode,
                        errorResponse.errorMessage,
                        null
                    )
                    return@verifyPin
                }

                val map = mapOf(
                    "status" to (successResponse?.message ?: "success")
                )
                result.success(map)
            }
        } catch (e: Exception) {
            result.error("VERIFY_PIN_ERROR", e.message, null)
        }
    }

    private fun handleChangePin(call: MethodCall, result: Result) {
        try {
            val oldPin = call.argument<String>("oldPin")
            val newPin = call.argument<String>("newPin")
            if (oldPin == null || newPin == null) {
                result.error("INVALID_ARGS", "Missing pin arguments", null)
                return
            }

            val api = NICardManagementConfig.api
            if (api == null) {
                result.error("NOT_INITIALIZED", "SDK not initialized", null)
                return
            }

            api.changePin(oldPin, newPin) { successResponse, errorResponse ->
                if (errorResponse != null) {
                    result.error(
                        errorResponse.errorCode,
                        errorResponse.errorMessage,
                        null
                    )
                    return@changePin
                }

                val map = mapOf(
                    "status" to (successResponse?.message ?: "success")
                )
                result.success(map)
            }
        } catch (e: Exception) {
            result.error("CHANGE_PIN_ERROR", e.message, null)
        }
    }

    private fun handleGetPin(result: Result) {
        try {
            val api = NICardManagementConfig.api
            if (api == null) {
                result.error("NOT_INITIALIZED", "SDK not initialized", null)
                return
            }

            api.getPin { viewPinResponse, errorResponse ->
                if (errorResponse != null) {
                    result.error(
                        errorResponse.errorCode,
                        errorResponse.errorMessage,
                        null
                    )
                    return@getPin
                }

                result.success(viewPinResponse)
            }
        } catch (e: Exception) {
            result.error("GET_PIN_ERROR", e.message, null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
