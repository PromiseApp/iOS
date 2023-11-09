import Moya
import Foundation

protocol ErrorHandler {
    func handle(error: Error) -> String
}

class NetworkErrorHandler: ErrorHandler {
    func handle(error: Error) -> String {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .statusCode(let response):
                if (400...499).contains(response.statusCode) {
                    return "It's a client error."
                } else if (500...599).contains(response.statusCode) {
                    return "It's a server error."
                }
            case .underlying(let nsError as NSError, _):
                if nsError.domain == NSURLErrorDomain {
                    switch nsError.code {
                    case NSURLErrorNotConnectedToInternet:
                        return "No internet connection."
                    case NSURLErrorTimedOut:
                        return "The request timed out."
                    case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
                        return "Can't connect to the server."
                    default:
                        return "A network error occurred."
                    }
                }
            default:
                return "An error occurred."
            }
        }
        return "An unknown error occurred."
    }
}
