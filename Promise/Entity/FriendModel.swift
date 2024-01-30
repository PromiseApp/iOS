import Foundation
import RealmSwift
import UIKit

struct Friend{
    var userImage: UIImage
    let name: String
    let level: String
    var isSelected: Bool
}

struct RequestFriend{
    var userImage: UIImage
    let name: String
    let level: String
    let requesterID: String
}

class RequestFriendModel: Object {
    @Persisted(primaryKey: true) var requesterID: String = ""
}
