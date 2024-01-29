import RxSwift
import RealmSwift
import UIKit
import Foundation
import Moya
import RxCocoa
import RxFlow
import StompClientLib

class ChatRoomViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    let stompService: StompService
    let promiseID: Int
    var currentRoomId: Int?
    
    var messages: [ChatRoom] = []
    let userNickname = DatabaseManager.shared.fetchUser()?.nickname
    
    let leftButtonTapped = PublishRelay<Void>()
    let sendButtonTapped = PublishRelay<Void>()
    let chatTextFieldRelay = BehaviorRelay<String?>(value: "")
    let isParticipantViewVisible = PublishRelay<Bool>()
    
    let chatRelay = BehaviorRelay<[ChatCell]>(value: [])
    var chatDriver: Driver<[ChatCell]>{
        return chatRelay.asDriver(onErrorJustReturn: [])
    }
    
    init(stompService: StompService, promiseID: Int){
        self.stompService = stompService
        self.promiseID = promiseID
        self.currentRoomId = promiseID
        self.stompService.setCurrentRoomId(roomId: self.currentRoomId)
        self.markMessagesAsRead(roomId: promiseID)
        
        self.convertToChatCell(chatRooms: self.stompService.loadMessages(roomId: promiseID)) { [weak self] lastMessages in
            self?.chatRelay.accept(lastMessages)
        }

        // 새 메시지 수신 시 처리
        self.stompService.messageRelay
            .subscribe(onNext: { [weak self] message in
                self?.convertToChatCell(chatRooms: message) { convertedMessages in
                    self?.chatRelay.accept(convertedMessages)
                }
            })
            .disposed(by: disposeBag)
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(ChatStep.popView)
            })
            .disposed(by: disposeBag)
        
        sendButtonTapped
            .withLatestFrom(chatTextFieldRelay)
            .subscribe(onNext: { [weak self] chat in
                self?.sendMessage(text: chat ?? "")
                self?.chatTextFieldRelay.accept(nil)
            })
            .disposed(by: disposeBag)
        
    }
    
    func sendMessage(text: String) {
        let destination = "/pub/chat/message"
        var userImg: String? = nil
        if let user = DatabaseManager.shared.fetchUser(){
           userImg = user.image
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
        let sendDate = dateFormatter.string(from: Date())
        
        let jsonBody: [String: Any] = ["roomId": promiseID , "senderNickname": userNickname, "memberImg": userImg, "message": text, "sendDate": sendDate]

        self.stompService.socketClient.sendJSONForDict(dict: jsonBody as AnyObject, toDestination: destination)
    }
    
    func convertToChatCell(chatRooms: [ChatRoom], completion: @escaping ([ChatCell]) -> Void) {
        var chatCells: [ChatCell] = []
        let dispatchGroup = DispatchGroup()

        chatRooms.forEach { chatRoom in
            dispatchGroup.enter()
            var userImage: UIImage? = UIImage(named: "user")
            var chatCell = ChatCell(
                promiseID: chatRoom.roomId,
                nickname: chatRoom.senderNickname,
                userImage: userImage,
                content: chatRoom.messageText,
                chatDate: chatRoom.timestamp
            )

            if let imageUrl = chatRoom.userImage {
                ImageDownloadManager.shared.downloadImage(urlString: imageUrl) { image in
                    chatCell.userImage = image ?? UIImage(named: "user")
                    chatCells.append(chatCell)
                    dispatchGroup.leave()
                }
            } else {
                chatCells.append(chatCell)
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion(chatCells)
        }
    }

    
//    func convertToChatCell(chatRooms: [ChatRoom]) -> [ChatCell] {
//        
//        return chatRooms.map { chatRoom in
//            var userImage: UIImage? = UIImage(named: "user")
//            if let imageUrl = chatRoom.userImage {
//                ImageDownloadManager.shared.downloadImage(urlString: imageUrl) { image in
//                    userImage = image ?? UIImage(named: "user")!
//                }
//            }
//            return ChatCell(
//                promiseID: chatRoom.roomId,
//                nickname: chatRoom.senderNickname,
//                userImage: userImage,
//                content: chatRoom.messageText,
//                chatDate: chatRoom.timestamp
//            )
//        }
//    }

    func markMessagesAsRead(roomId: Int) {
        let realm = try! Realm()
        try! realm.write {
            let messages = realm.objects(ChatRoom.self).filter("roomId == \(roomId)")
            for message in messages {
                message.isRead = true
            }
        }
    }
    
    func leaveChatRoom() {
        self.stompService.setCurrentRoomId(roomId: nil)
    }
    
}
