import Foundation
import Moya

enum AuthAPI {
    case signup(account: String, password: String, nickname: String, image: String?)
    case login(account: String, password: String)
    case duplicateCheckAccount(account: String)
    case duplicateCheckNickname(nickname: String)
}

extension AuthAPI: TargetType {

    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .signup:
            return "/register"
        case .login:
            return "/login"
        case .duplicateCheckNickname(let nickname):
            return "/\(nickname)/exists/nickname"
        case .duplicateCheckAccount(let account):
            return "/\(account)/exists/account"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signup:
            return .post
        case .login:
            return .post
        case .duplicateCheckNickname:
            return .get
        case .duplicateCheckAccount:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .signup(let account, let password, let nickname, let image):
            var parameters: [String: Any] = [
                "account": account,
                "password": password,
                "nickname": nickname
            ]
            
            if let image = image {
                parameters["img"] = image
            }
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
            
        case .login(let account, let password):
            return .requestParameters(parameters: ["account": account, "password": password], encoding: JSONEncoding.default)
        case .duplicateCheckNickname:
            return .requestPlain
        case .duplicateCheckAccount:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
}
