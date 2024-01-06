import UIKit
import RxSwift
import RxCocoa
import RealmSwift


class UserSession {
    static let shared = UserSession()
    var deviceToken: String = ""
    var account: String = ""
    var nickname: String = ""
    var image: String?
    var level: Int = 0
    var exp: Int = 0
    var role: String = ""
    var token: String = ""

    private init() {}
    
}

class User: Object {
    @Persisted(primaryKey: true) var objectID:ObjectId
    @Persisted var account: String
    @Persisted var password: String
    @Persisted var nickname: String
    @Persisted var image: String?
    @Persisted var level: Int
    @Persisted var exp: Int
    @Persisted var role: String
    @Persisted var token: String
    
    convenience init(account: String, password: String,  nickname: String, image: String? = nil, level: Int, exp: Int, role: String, token: String) {
        self.init()
        self.account = account
        self.password = password
        self.nickname = nickname
        self.image = image
        self.level = level
        self.exp = exp
        self.role = role
        self.token = token
    }
}

