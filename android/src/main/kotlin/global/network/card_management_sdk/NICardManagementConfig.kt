package global.network.card_management_sdk

import ae.network.nicardmanagementsdk.api.interfaces.NICardManagementAPI as NICardManagementAPIInterface
import ae.network.nicardmanagementsdk.api.models.input.NIConnectionProperties
import ae.network.nicardmanagementsdk.api.models.input.NIInput

object NICardManagementConfig {

    var api: NICardManagementAPIInterface? = null
        private set

    var input: NIInput? = null
        private set

    fun initialize(
        token: String,
        rootUrl: String,
        bankCode: String,
        cardIdentifierId: String,
        cardIdentifierType: String,
        extraNetworkHeaders: Map<String, String>? = null
    ) {
        val connectionProperties = NIConnectionProperties(
            token = token,
            rootUrl = rootUrl,
            extraNetworkHeaders = extraNetworkHeaders
        )

        input = NIInput(
            bankCode = bankCode,
            cardIdentifierId = cardIdentifierId,
            cardIdentifierType = cardIdentifierType,
            connectionProperties = connectionProperties
        )

        api = ae.network.nicardmanagementsdk.api.implementation.NICardManagement
    }
}
