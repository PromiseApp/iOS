import Foundation
import Alamofire

enum LoginAPI: Requestable, Responsable {
    
    case getEmailExists(email: String)
    case postRegister(account: String, password: String, nickname: String)
    case postLogin(account: String, password: String)

    var baseURL: URL {
        return URL(string: "http://43.201.252.19:8080")!
    }
    
    var path: String {
        switch self {
        case .getEmailExists(let email):
            return "/\(email)/exists"
        case .postRegister:
            return "/register"
        case .postLogin:
            return "/login"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getEmailExists:
            return .get
        case .postRegister:
            return .post
        case .postLogin:
            return .post

        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getEmailExists:
            return nil
        case .postRegister(let account, let password, let nickname):
            return ["account": account, "password": password, "nickname": nickname]
        case .postLogin(let account, let password):
            return ["account": account, "password": password]
        }
    }
    
    var headers: HTTPHeaders? {
        return ["Content-Type": "application/json"]
    }
    
    typealias ResponseType = Decodable

        var responseType: ResponseType.Type {
            switch self {
            case .getEmailExists:
                return EmailDetails.self
            case .postRegister:
                return RegisterDetails.self
            case .postLogin:
                return LoginDetails.self
            }
        }

}
struct EmailDetails: Decodable {
    let email: String
}

struct RegisterDetails: Decodable {
    let account: String
    let password: String
}

struct LoginDetails: Decodable {
    let result: Bool
}
