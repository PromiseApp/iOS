import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()

    private init() {}

    func fetchUser() -> User? {
        let realm = try! Realm()
        return realm.objects(User.self).first
    }
}
