import RealmSwift
import UIKit
import Foundation

class ChatList: Object {
    @Persisted(primaryKey: true) var roomId: Int
    @Persisted var messages: List<ChatRoom>

}

class ChatRoom: Object {
    @Persisted(primaryKey: true) var id = UUID().uuidString
    @Persisted var roomId: Int = 0
    @Persisted var senderNickname: String = ""
    @Persisted var userImage: String?
    @Persisted var messageText: String = ""
    @Persisted var timestamp: String = ""
    @Persisted var isRead: Bool = false
    @Persisted(originProperty: "messages") var chatRoom: LinkingObjects<ChatList>

}

struct ChatListCell {
    let promiseID: Int
    let title: String
    let promiseCnt: Int
    let promiseDate: String
    let messageTime: String
    let unReadMessagesCnt: Int
}



struct ChatCell {
    let promiseID: Int
    let nickname: String
    var userImage: UIImage?
    let content: String
    let chatDate: String
}

