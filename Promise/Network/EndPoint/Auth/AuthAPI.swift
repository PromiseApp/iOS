import Foundation
import UIKit
import Moya

enum AuthAPI {
    case signup(account: String, password: String, nickname: String, image: String?)
    case login(account: String, password: String)
    case duplicateCheckAccount(account: String)
    case duplicateCheckNickname(nickname: String)
    case postEmail(account: String)
    case changePassword(password: String)
    case changeNickname(nickname: String)
    case changeImage(img: UIImage?)
    case withdraw
}

extension AuthAPI: TargetType {

    var baseURL: URL {
        return URL(string: "http://43.200.141.247:8080")!
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
            return .requestParameters(parameters: ["account": account, "password": password, "deviceToken": UserSession.shared.deviceToken], encoding: JSONEncoding.default)
        case .duplicateCheckNickname:
            return .requestPlain
        case .duplicateCheckAccount:
            return .requestPlain
        case .postEmail(let account):
            return .requestParameters(parameters: ["account": account], encoding: JSONEncoding.default)
        case .changePassword(let password):
            let parameters = [
                "password": password,
                "isImgUpdate": false
            ] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .changeNickname(let nickname):
            let parameters = [
                "nickname": nickname,
                "isImgUpdate": false
            ] as [String : Any]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .changeImage(let img):
            
//            var multipartData: [MultipartFormBodyPart] = []  // Ensure the array is of the correct type
//
//            let imgUpdateData = MultipartFormBodyPart(provider: .data("true".data(using: .utf8)!), name: "imgUpdate")
//            multipartData.append(imgUpdateData)
//
//            if let img = img, let imageData = img.jpegData(compressionQuality: 1.0) {
//                // 이미지 데이터 추가
//                let imgData = MultipartFormBodyPart(provider: .data(imageData), name: "img", fileName: "image.png", mimeType: "image/png")
//                multipartData.append(imgData)
//            }
//            return .uploadMultipart(multipartData)
            
            var multipartData:MultipartFormData
            let imgUpdateData = MultipartFormBodyPart(provider: .data("true".data(using: .utf8)!), name: "imgUpdate")
            //multipartData.append(imgUpdateData)
            if let img = img, let imageData = img.jpegData(compressionQuality: 1.0) {
                // 이미지 데이터 추가
                let imgData = MultipartFormBodyPart(provider: .data(imageData), name: "img", fileName: "image.png", mimeType: "image/png")
                multipartData = [imgUpdateData, imgData]
            }
            else{
                multipartData = [imgUpdateData]
            }
            // Or if you want to specify the boundary and file manager:
            // let multipartData = MultipartFormData(fileManager: .default, boundary: "...", parts: [gifData, descriptionData])
            
            return .uploadMultipartFormData(multipartData)
        case .withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        var jsonHeaders = ["Content-Type": "application/json"]
        var multiHeaders = ["Content-Type": "multipart/form-data"]
        if let user = DatabaseManager.shared.fetchUser(){
            jsonHeaders["Authorization"] = "Bearer \(user.token)"
            multiHeaders["Authorization"] = "Bearer \(user.token)"
        }
        switch self{
        case .signup:
            return multiHeaders
        case .login:
            return jsonHeaders
        case .duplicateCheckNickname:
            return jsonHeaders
        case .duplicateCheckAccount:
            return jsonHeaders
        case .postEmail:
            return jsonHeaders
        case .changePassword:
            return jsonHeaders
        case .changeNickname:
            return jsonHeaders
        case .changeImage:
            return multiHeaders
        case .withdraw:
            return jsonHeaders
        }
        
    }
    
}
