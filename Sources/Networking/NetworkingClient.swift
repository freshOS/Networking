import Foundation
import Combine

public struct NetworkingClient {

    /**
        Instead of using the same keypath for every call eg: "collection",
        this enables to use a default keypath for parsing collections.
        This is overidden by the per-request keypath if present.
     
     */
    public var defaultCollectionParsingKeyPath: String?
    let baseURL: String
    public var headers = [String: String]()
    public var parameterEncoding = ParameterEncoding.urlEncoded
    public var timeout: TimeInterval?

    /**
        Prints network calls to the console.
        Values Available are .None, Calls and CallsAndResponses.
        Default is None
    */
    public var logLevels: NetworkingLogLevel {
        get { return logger.logLevels }
        set { logger.logLevels = newValue }
    }

    private let logger = NetworkingLogger()

    public init(baseURL: String, timeout: TimeInterval? = nil) {
        self.baseURL = baseURL
        self.timeout = timeout
    }
}

