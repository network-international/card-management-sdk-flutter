package global.network.card_management_sdk

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

/** CardManagementSdkPlugin */
class CardManagementSdkPlugin :
    FlutterPlugin,
    MethodCallHandler {

    private lateinit var channel: MethodChannel
    private val pluginScope = CoroutineScope(SupervisorJob() + Dispatchers.Main)

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

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        pluginScope.cancel()
    }

    // region Handlers

    private fun handleInitialize(call: MethodCall, result: Result) {
        val token = call.argument<String>("token")
        val rootUrl = call.argument<String>("rootUrl")
        val bankCode = call.argument<String>("bankCode")
        val cardIdentifierId = call.argument<String>("cardIdentifierId")
        val cardIdentifierType = call.argument<String>("cardIdentifierType")

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
            cardIdentifierType = cardIdentifierType
        )
        result.success(null)
    }

    private fun handleGetCardDetails(result: Result) {
        val api = NICardManagementConfig.api
        val input = NICardManagementConfig.input
        if (api == null || input == null) {
            result.error("NOT_INITIALIZED", "SDK not initialized", null)
            return
        }
        pluginScope.launch {
            val response = api.getCardDetails(input)
            val error = response.error
            if (error != null) {
                result.success(mapOf("errorCode" to error.errorCode, "errorMessage" to error.message))
            } else {
                val details = response.cardDetails
                result.success(
                    mapOf(
                        "clearPan" to details?.clearPan,
                        "maskedPan" to details?.maskedPan,
                        "expiry" to details?.expiry,
                        "clearCVV2" to details?.clearCVV2,
                        "cardholderName" to details?.cardholderName
                    ).filterValues { it != null }
                )
            }
        }
    }

    private fun handleSetPin(call: MethodCall, result: Result) {
        val pin = call.argument<String>("pin")
        if (pin == null) {
            result.error("INVALID_ARGS", "Missing pin argument", null)
            return
        }
        val api = NICardManagementConfig.api
        val input = NICardManagementConfig.input
        if (api == null || input == null) {
            result.error("NOT_INITIALIZED", "SDK not initialized", null)
            return
        }
        pluginScope.launch {
            val response = api.setPin(pin, input)
            val error = response.error
            if (error != null) {
                result.success(mapOf("errorCode" to error.errorCode, "errorMessage" to error.message))
            } else {
                result.success(mapOf("status" to "success"))
            }
        }
    }

    private fun handleVerifyPin(call: MethodCall, result: Result) {
        val pin = call.argument<String>("pin")
        if (pin == null) {
            result.error("INVALID_ARGS", "Missing pin argument", null)
            return
        }
        val api = NICardManagementConfig.api
        val input = NICardManagementConfig.input
        if (api == null || input == null) {
            result.error("NOT_INITIALIZED", "SDK not initialized", null)
            return
        }
        pluginScope.launch {
            val response = api.verifyPin(pin, input)
            val error = response.error
            if (error != null) {
                result.success(mapOf("errorCode" to error.errorCode, "errorMessage" to error.message))
            } else {
                result.success(mapOf("status" to "success"))
            }
        }
    }

    private fun handleChangePin(call: MethodCall, result: Result) {
        val oldPin = call.argument<String>("oldPin")
        val newPin = call.argument<String>("newPin")
        if (oldPin == null || newPin == null) {
            result.error("INVALID_ARGS", "Missing pin arguments", null)
            return
        }
        val api = NICardManagementConfig.api
        val input = NICardManagementConfig.input
        if (api == null || input == null) {
            result.error("NOT_INITIALIZED", "SDK not initialized", null)
            return
        }
        pluginScope.launch {
            val response = api.changePin(oldPin, newPin, input)
            val error = response.error
            if (error != null) {
                result.success(mapOf("errorCode" to error.errorCode, "errorMessage" to error.message))
            } else {
                result.success(mapOf("status" to "success"))
            }
        }
    }

    private fun handleGetPin(result: Result) {
        val api = NICardManagementConfig.api
        val input = NICardManagementConfig.input
        if (api == null || input == null) {
            result.error("NOT_INITIALIZED", "SDK not initialized", null)
            return
        }
        pluginScope.launch {
            val response = api.viewPin(input)
            val error = response.error
            if (error != null) {
                result.error(error.errorCode ?: "ERROR", error.message, null)
            } else {
                result.success(response.viewPin?.pin)
            }
        }
    }

    // endregion
}

