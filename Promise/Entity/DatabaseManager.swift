import RealmSwift

class DatabaseManager {
    static let shared = DatabaseManager()

    private init() {}

    func fetchUser() -> User? {
        let realm = try! Realm()
        return realm.objects(User.self).first
    }
    
    func updateAccessToken(newToken: String) {
        do {
            let realm = try Realm()
            if let user = realm.objects(User.self).first {
                try realm.write {
                    user.accessToken = newToken
                }
            }
        } catch {
            print("Realm 에러: \(error.localizedDescription)")
        }
    }
}
