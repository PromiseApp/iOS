import StompClientLib
import RealmSwift
import RxCocoa

class StompService {
    var socketClient = StompClientLib()
    var messageRelay = PublishRelay<[ChatRoom]>()
    var currentRoomId: Int?
    
    func connectSocket(){
        let url = URL(string: "ws://15.164.166.199:8080/ws")!
        if let accessToken = KeychainManager.shared.readToken(for: "AccessToken") {
            socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: self,connectionHeaders: ["Authorization":"Bearer \(accessToken)"])
        }
    }
    
    func subscribeToChatRoom(promiseID: Int) {
        let subscribePath = "/sub/chat/room/\(promiseID)"
        socketClient.subscribe(destination: subscribePath)
    }
    
    func unSubscribeToChatRoom(promiseID: Int) {
        let subscribePath = "/sub/chat/room/\(promiseID)"
        socketClient.unsubscribe(destination: subscribePath)
    }
    
    func subscribeToAllChatRooms() {
        let realm = try! Realm()
        let allChatLists = realm.objects(ChatList.self)

        for chatList in allChatLists {
            self.subscribeToChatRoom(promiseID: chatList.roomId)
        }
    }
    
    func setCurrentRoomId(roomId: Int?) {
        self.currentRoomId = roomId
    }

    func saveMessage(roomId: Int, senderNickname: String, userImage: String?, messageText: String, timestamp: String, isRead: Bool) {
        let realm = try! Realm()
        let chatList = realm.object(ofType: ChatList.self, forPrimaryKey: roomId)

        let newMessage = ChatRoom()
        newMessage.roomId = roomId
        newMessage.senderNickname = senderNickname
        newMessage.userImage = userImage
        newMessage.messageText = messageText
        newMessage.timestamp = timestamp
        newMessage.isRead = isRead

        try! realm.write {
            chatList!.messages.append(newMessage)
            if realm.object(ofType: ChatList.self, forPrimaryKey: roomId) == nil {
                realm.add(chatList!,update: .modified)
            }
        }
    }
    
    func updateMessagesForRoom(roomId: Int) {
        let messages = loadMessages(roomId: roomId)
        messageRelay.accept(messages)
    }
    
    func loadMessages(roomId: Int) -> [ChatRoom] {
        let realm = try! Realm()
        if let chatList = realm.object(ofType: ChatList.self, forPrimaryKey: roomId) {
            return Array(chatList.messages.sorted(byKeyPath: "timestamp", ascending: true))
        }
        return []
    }
    
}

extension StompService: StompClientLibDelegate{
    func stompClient(client: StompClientLib!, didReceiveMessageWithJSONBody jsonBody: AnyObject?, akaStringBody stringBody: String?, withHeader header: [String : String]?, withDestination destination: String) {
        //print("Destination : \(destination)")
        //print("JSON Body : \(String(describing: jsonBody))")
        print("String Body : \(stringBody ?? "nil")")
        
        guard let data = stringBody?.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let dict = json as? [String: Any],
              let roomId = dict["roomId"] as? Int,
              let senderNickname = dict["senderNickname"] as? String,
              let messageText = dict["message"] as? String,
              let sendDate = dict["sendDate"] as? String else {
            print("Error parsing JSON")
            return
        }
        
        var image: String? = nil
        if let imageUrl = dict["memberImg"] as? String{
            image = imageUrl
        }
        let isRead = roomId == self.currentRoomId ?? 0
        self.saveMessage(roomId: roomId, senderNickname: senderNickname, userImage: image, messageText: messageText, timestamp: sendDate, isRead: isRead)
        self.updateMessagesForRoom(roomId: roomId)
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is connected")
        self.subscribeToAllChatRooms()
    }
    
    func serverDidSendReceipt(client: StompClientLib!, withReceiptId receiptId: String) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(client: StompClientLib!, withErrorMessage description: String, detailedErrorMessage message: String?) {
        print(description)
        print("Error Send : \(String(describing: message))")
        
    }
    
    func serverDidSendPing() {
        print("Server ping")
    }
}
