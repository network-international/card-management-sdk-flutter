import NICardManagementSDKCore

class NICardManagementConfig {
    static let shared = NICardManagementConfig()

    private(set) var api: NICardManagementAPI?
    private var extraHeadersProvider: AdditionalDemoHeadersProvider?
    private var logger: DemoLogger?

    private init() {}

    func initialize(
        token: String,
        rootUrl: String,
        bankCode: String,
        cardIdentifierId: String,
        cardIdentifierType: String,
        debugLogToConsole: Bool = false,
        extraNetworkHeaders: [String: String]? = nil
    ) {
        let tokenFetcher = TokenFetcherFactory.makeSimpleWrapper(tokenValue: token)
        let headersProvider = AdditionalDemoHeadersProvider(extraHeaders: extraNetworkHeaders ?? [:])
        logger = debugLogToConsole ? DemoLogger() : nil

        api = NICardManagementAPI(
            rootUrl: rootUrl,
            cardIdentifierId: cardIdentifierId,
            cardIdentifierType: cardIdentifierType,
            bankCode: bankCode,
            tokenFetchable: tokenFetcher,
            extraHeadersProvider: headersProvider,
            logger: logger,
        )
    }
}
// MARK: - helper structures
extension NICardManagementConfig {
    fileprivate class AdditionalDemoHeadersProvider: NICardManagementExtraHeaders {
        let extraHeaders: [String: String]
        // put your custom headers here if needed
        init(extraHeaders: [String: String] = [:]) {
            self.extraHeaders = extraHeaders
        }
        func additionalNetworkHeaders() -> [String : String] {
            extraHeaders
        }
    }
    
    fileprivate class DemoLogger: NICardManagementLogger {
        func logNICardManagementMessage(_ message: String) {
            print(message)
        }
    }
}
