import NICardManagementSDK

class NICardManagementConfig {
    static let shared = NICardManagementConfig()

    private(set) var api: NICardManagementAPI?

    private init() {}

    func initialize(
        token: String,
        rootUrl: String,
        bankCode: String,
        cardIdentifierId: String,
        cardIdentifierType: String
    ) {
        let tokenFetcher = TokenFetcherFactory.makeSimpleWrapper(tokenValue: token)
        let headersProvider = AdditionalDemoHeadersProvider()

        api = NICardManagementAPI(
            rootUrl: rootUrl,
            networkServiceLogger: nil,
            tokenFetchable: tokenFetcher,
            extraHeadersProvider: headersProvider,
            bankCode: bankCode,
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType
        )
    }
}
