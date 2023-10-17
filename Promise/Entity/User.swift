class UserManager {
    static let shared = UserManager()
    
    var userModel = UserModel()
    
    private init() {}
}

struct UserModel: Codable {
    var id: Int?
    var account: String?
    var nickname: String?
    var token: String?
}
