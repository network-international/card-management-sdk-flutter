package global.network.card_management_sdk

import ae.network.nicardmanagementsdk.api.interfaces.NICardManagementAPI as NICardManagementAPIInterface
import ae.network.nicardmanagementsdk.api.models.input.NIInput
import ae.network.nicardmanagementsdk.api.models.output.NIErrorResponse
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

/** CardManagementSdkPlugin */
class CardManagementSdkPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private val mainScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "card_management_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
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

    private fun handleInitialize(call: MethodCall, result: Result) {
        try {
            val token = call.argument<String>("token")
            val rootUrl = call.argument<String>("rootUrl")
            val bankCode = call.argument<String>("bankCode")
            val cardIdentifierId = call.argument<String>("cardIdentifierId")
            val cardIdentifierType = call.argument<String>("cardIdentifierType")
            val extraNetworkHeaders = call.argument<Map<String, String>>("extraNetworkHeaders")

            if (token == null || rootUrl == null || bankCode == null ||
                cardIdentifierId == null || cardIdentifierType == null
            ) {
                result.error("INVALID_ARGS", "Missing required arguments", null)
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
        val sdkContext = getSdkContext(result) ?: return
        launchSdkCall(result, "GET_CARD_DETAILS_ERROR") {
            val response = withContext(Dispatchers.IO) {
                sdkContext.api.getCardDetails(sdkContext.input)
            }

            response.isError?.let {
                result.error(errorCode(it), it.errorMessage, null)
                return@launchSdkCall
            }

            val cardDetails = response.details
            if (cardDetails == null) {
                result.error("INVALID_RESPONSE", "Missing card details in response", null)
                return@launchSdkCall
            }

            val map = mutableMapOf<String, Any>()
            cardDetails.clearPan?.let { map["clearPan"] = it }
            cardDetails.maskedPan?.let { map["maskedPan"] = it }
            cardDetails.expiry?.let { map["expiry"] = it }
            cardDetails.clearCVV2?.let { map["clearCVV2"] = it }
            cardDetails.clearCardholderName?.let { map["cardholderName"] = it }
            result.success(map)
        }
    }

    private fun handleSetPin(call: MethodCall, result: Result) {
        val pin = call.argument<String>("pin")
        if (pin == null) {
            result.error("INVALID_ARGS", "Missing pin argument", null)
            return
        }

        val sdkContext = getSdkContext(result) ?: return
        launchSdkCall(result, "SET_PIN_ERROR") {
            val response = withContext(Dispatchers.IO) {
                sdkContext.api.setPin(pin, sdkContext.input)
            }

            response.isError?.let {
                result.error(errorCode(it), it.errorMessage, null)
                return@launchSdkCall
            }

            result.success(mapOf("status" to (response.isSuccess?.message ?: "success")))
        }
    }

    private fun handleVerifyPin(call: MethodCall, result: Result) {
        val pin = call.argument<String>("pin")
        if (pin == null) {
            result.error("INVALID_ARGS", "Missing pin argument", null)
            return
        }

        val sdkContext = getSdkContext(result) ?: return
        launchSdkCall(result, "VERIFY_PIN_ERROR") {
            val response = withContext(Dispatchers.IO) {
                sdkContext.api.verifyPin(pin, sdkContext.input)
            }

            response.isError?.let {
                result.error(errorCode(it), it.errorMessage, null)
                return@launchSdkCall
            }

            result.success(mapOf("status" to (response.isSuccess?.message ?: "success")))
        }
    }

    private fun handleChangePin(call: MethodCall, result: Result) {
        val oldPin = call.argument<String>("oldPin")
        val newPin = call.argument<String>("newPin")
        if (oldPin == null || newPin == null) {
            result.error("INVALID_ARGS", "Missing pin arguments", null)
            return
        }

        val sdkContext = getSdkContext(result) ?: return
        launchSdkCall(result, "CHANGE_PIN_ERROR") {
            val response = withContext(Dispatchers.IO) {
                sdkContext.api.changePin(oldPin, newPin, sdkContext.input)
            }

            response.isError?.let {
                result.error(errorCode(it), it.errorMessage, null)
                return@launchSdkCall
            }

            result.success(mapOf("status" to (response.isSuccess?.message ?: "success")))
        }
    }

    private fun handleGetPin(result: Result) {
        val sdkContext = getSdkContext(result) ?: return
        launchSdkCall(result, "GET_PIN_ERROR") {
            val response = withContext(Dispatchers.IO) {
                sdkContext.api.viewPin(sdkContext.input)
            }

            response.error?.let {
                result.error(errorCode(it), it.errorMessage, null)
                return@launchSdkCall
            }

            result.success(response.pin?.encrypted_pin)
        }
    }

    private fun getSdkContext(result: Result): SdkContext? {
        val api = NICardManagementConfig.api
        if (api == null) {
            result.error("NOT_INITIALIZED", "SDK not initialized", null)
            return null
        }

        val input = NICardManagementConfig.input
        if (input == null) {
            result.error("NOT_INITIALIZED", "SDK input is not initialized", null)
            return null
        }

        return SdkContext(api, input)
    }

    private fun launchSdkCall(result: Result, errorCode: String, block: suspend () -> Unit) {
        mainScope.launch {
            try {
                block()
            } catch (e: Exception) {
                result.error(errorCode, e.message, null)
            }
        }
    }

    private fun errorCode(errorResponse: NIErrorResponse): String = errorResponse.error.name

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        mainScope.cancel()
    }

    private data class SdkContext(
        val api: NICardManagementAPIInterface,
        val input: NIInput
    )
}
