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
    @Persisted var userImageBase64: String?
    @Persisted var messageText: String = ""
    @Persisted var timestamp: String = ""
    @Persisted var isRead: Bool = false
    @Persisted(originProperty: "messages") var chatRoom: LinkingObjects<ChatList>

}

struct ChatListCell{
    let promiseID: Int
    let title: String
    let cnt: Int
    let promiseDate: String
}

struct ChatCell {
    let promiseID: Int
    let nickname: String
    let userImage: UIImage?
    let content: String
    let chatDate: String
}

