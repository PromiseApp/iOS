import Foundation

struct LoginResponse: Codable {
    let resultCode: String
    let resultMessage: String
    let data: UserData
}

struct UserData: Codable{
    let userInfo: UserInfo
    let token: String
}

struct UserInfo: Codable{
    let account: String
    let nickname: String
    let level: Int
    let exp: Int
    let img: String?
    let roles: [Role]
}

struct Role: Codable {
    let name: String
}

struct SignupResponse: Codable{
    let resultCode: String
    let resultMessage: String
}

struct DuplicateCheckResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: DuplicateCheckData
}

struct DuplicateCheckData: Codable{
    let isDuplicated: Bool
}
