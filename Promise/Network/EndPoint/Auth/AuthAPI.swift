import Foundation
import Moya

enum AuthAPI {
    case signup(account: String, password: String, nickname: String, image: String?)
    case login(account: String, password: String)
    case duplicateCheckAccount(account: String)
    case duplicateCheckNickname(nickname: String)
    case postEmail(account: String)
    case changePassword(password: String)
    case changeNickname(nickname: String)
    case changeImage(img: String)
    case withdraw
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
        case .postEmail:
            return "/verify-code"
        case .changePassword:
            return "/member/update-profile"
        case .changeNickname:
            return "/member/update-profile"
        case .changeImage:
            return "/member/update-profile"
        case .withdraw:
            return "/member/withdraw"
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
        case .postEmail:
            return .post
        case .changePassword:
            return .patch
        case .changeNickname:
            return .patch
        case .changeImage:
            return .patch
        case .withdraw:
            return .delete
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
        case .postEmail(let account):
            return .requestParameters(parameters: ["account": account], encoding: JSONEncoding.default)
        case .changePassword(let password):
            let parameters = [
                "password": password
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .changeNickname(let nickname):
            let parameters = [
                "nickname": nickname
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .changeImage(let img):
            let parameters = [
                "img": img
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        if let user = DatabaseManager.shared.fetchUser(){
            headers["Authorization"] = "Bearer \(user.token)"
        }
        return headers
    }
    
}
