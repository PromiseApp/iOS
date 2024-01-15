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

    private init() {}
    
}

class User: Object {
    @Persisted(primaryKey: true) var objectID:ObjectId
    @Persisted var account: String
    @Persisted var nickname: String
    @Persisted var image: String?
    @Persisted var role: String
    @Persisted var accessToken: String
    @Persisted var refreshToken: String
    
    convenience init(account: String, nickname: String, image: String?, role: String, accessToken: String, refreshToken: String) {
        self.init()
        self.account = account
        self.nickname = nickname
        self.image = image
        self.role = role
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

