struct UserRegister: Decodable{
    let account: String
    let password: String
    let nickname: String
}

struct UserLogin: Decodable{
    let account: String
    let password: String
}
