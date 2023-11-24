import Foundation
import Moya

enum AuthAPI {
    case signup(account: String, password: String, nickname: String, image: String?)
    case login(account: String, password: String)
    case duplicateCheckAccount(account: String)
    case duplicateCheckNickname(nickname: String)
    case ChangePassword(password: String)
    case ChangeNickname(nickname: String)
    case ChangeImage(img: String)
    case Withdraw
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
        case .ChangePassword:
            return "/member/update-profile"
        case .ChangeNickname:
            return "/member/update-profile"
        case .ChangeImage:
            return "/member/update-profile"
        case .Withdraw:
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
        case .ChangePassword:
            return .patch
        case .ChangeNickname:
            return .patch
        case .ChangeImage:
            return .patch
        case .Withdraw:
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
        case .ChangePassword(let password):
            let parameters = [
                "password": password
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .ChangeNickname(let nickname):
            let parameters = [
                "nickname": nickname
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .ChangeImage(let img):
            let parameters = [
                "img": img
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .Withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        headers["Authorization"] = "Bearer \(UserSession.shared.token)"
        return headers
    }
    
}
