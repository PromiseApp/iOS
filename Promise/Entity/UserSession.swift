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
    
}

