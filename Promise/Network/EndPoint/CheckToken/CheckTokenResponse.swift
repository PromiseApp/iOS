struct CheckTokenResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: AccessTokenInfo
}

struct AccessTokenInfo: Codable{
    let accessToken: String
}
