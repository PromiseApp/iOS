import Foundation
import Moya

enum CheckTokenAPI {
    case checkToken(refreshToken: String)
}

extension CheckTokenAPI: TargetType {

    var baseURL: URL {
        return URL(string: "http://15.164.166.199:8080")!
    }
    
    var path: String {
        switch self {
        case .checkToken:
            return "/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .checkToken(let refreshToken):
            let parameters = [
                "refreshToken": refreshToken
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        if let user = DatabaseManager.shared.fetchUser(){
            headers["Authorization"] = "Bearer \(user.accessToken)"
        }
        return headers
    }
    
}
