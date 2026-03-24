package global.network.card_management_sdk

import ae.network.nicardmanagementsdk.api.implementation.NICardManagementAPI
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
        cardIdentifierType: String
    ) {
        val connectionProperties = NIConnectionProperties(
            token = token,
            bankUrl = rootUrl
        )

        input = NIInput(
            bankCode = bankCode,
            cardIdentifierId = cardIdentifierId,
            cardIdentifierType = cardIdentifierType,
            connectionProperties = connectionProperties
        )

        api = NICardManagementAPI()
    }
}
