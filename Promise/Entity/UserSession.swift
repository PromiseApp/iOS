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
    @Persisted var accessToken: String
    @Persisted var refreshToken: String
    
    convenience init(accessToken: String, refreshToken: String) {
        self.init()
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

