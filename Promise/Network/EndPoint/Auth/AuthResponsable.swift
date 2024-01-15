struct AuthResponse: Codable{
    let resultCode: String
    let resultMessage: String
}

struct LoginResponse: Codable {
    let resultCode: String
    let resultMessage: String
    let data: UserData
}

struct UserData: Codable{
    let userInfo: UserInfo
    let accessToken: String
    let refreshToken: String
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

struct DuplicateCheckResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: DuplicateCheckData
}

struct DuplicateCheckData: Codable{
    let isDuplicated: Bool
}

struct PostEmailResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: PostEmailData
}

struct PostEmailData: Codable{
    let verifyCode: String
}

struct WithdrawResponse: Codable{
    let resultMessage: String
}

struct UpdateUserProfileResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: UserImage
}

struct UserImage: Codable{
    let img: String?
}
