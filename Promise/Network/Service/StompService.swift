import StompClientLib
import RealmSwift
import RxCocoa

class StompService {
    var socketClient = StompClientLib()
    var messageRelay = PublishRelay<[ChatRoom]>()
    //var messages:[ChatCell] = []
    
    func connectSocket(){
        let url = URL(string: "ws://43.200.141.247:8080/ws")!
        if let user = DatabaseManager.shared.fetchUser(){
            socketClient.openSocketWithURLRequest(request: NSURLRequest(url: url as URL) , delegate: self,connectionHeaders: ["Authorization":"Bearer \(user.token)"])
        }
    }
    
    func subscribeToChatRoom(promiseID: Int) {
        let subscribePath = "/sub/chat/room/\(promiseID)"
        socketClient.subscribe(destination: subscribePath)
    }
    
    func subscribeToAllChatRooms() {
        let realm = try! Realm()
        let allChatLists = realm.objects(ChatList.self)

        for chatList in allChatLists {
            self.subscribeToChatRoom(promiseID: chatList.roomId)
        }
    }

    func saveMessage(roomId: Int, senderNickname: String, userImageBase64: String?, messageText: String, timestamp: String) {
        let realm = try! Realm()
        let chatList = realm.object(ofType: ChatList.self, forPrimaryKey: roomId)

        let newMessage = ChatRoom()
        newMessage.roomId = roomId
        newMessage.senderNickname = senderNickname
        newMessage.userImageBase64 = userImageBase64
        newMessage.messageText = messageText
        newMessage.timestamp = timestamp
        newMessage.isRead = false

        try! realm.write {
            chatList!.messages.append(newMessage)
            if realm.object(ofType: ChatList.self, forPrimaryKey: roomId) == nil {
                realm.add(chatList!,update: .modified)
            }
        }
    }
    
    func loadMessages(roomId: Int) -> [ChatRoom] {
        let realm = try! Realm()
        if let chatList = realm.object(ofType: ChatList.self, forPrimaryKey: roomId) {
            return Array(chatList.messages.sorted(byKeyPath: "timestamp", ascending: true))
        }
        return []
    }
    
    func updateMessagesForRoom(roomId: Int) {
        let messages = loadMessages(roomId: roomId)
        messageRelay.accept(messages)
    }

    // 추가 메시지 불러오기 (예: 다음 20개)
    func fetchMoreMessages(for roomId: Int, offset: Int) -> [ChatRoom] {
        let realm = try! Realm()
        if let chatList = realm.object(ofType: ChatList.self, forPrimaryKey: roomId) {
            return Array(chatList.messages.sorted(byKeyPath: "timestamp", ascending: false).suffix(from: offset).prefix(20))
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
              let imageBase64 = dict["memberImg"] as? String,
              let senderNickname = dict["senderNickname"] as? String,
              let messageText = dict["message"] as? String,
              let sendDate = dict["sendDate"] as? String else {
            print("Error parsing JSON")
            return
        }
        
        self.saveMessage(roomId: roomId, senderNickname: senderNickname, userImageBase64: imageBase64, messageText: messageText, timestamp: sendDate)
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
