import RxSwift
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
        self.stompService.subscribeToChatRoom(promiseID: 31)
        let lastMessages = self.convertToChatCell(chatRooms: self.stompService.loadMessages(roomId: promiseID))
        self.chatRelay.accept(lastMessages)
        
        self.stompService.messageRelay
            .subscribe(onNext: { [weak self] message in
                let messages = self?.convertToChatCell(chatRooms: message)
                self?.chatRelay.accept(messages!)
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
    
    func convertToChatCell(chatRooms: [ChatRoom]) -> [ChatCell] {
        return chatRooms.map { chatRoom in
            var userImage: UIImage? = UIImage(named: "user")
            if let base64String = chatRoom.userImageBase64,
               let imageData = Data(base64Encoded: base64String) {
                userImage = UIImage(data: imageData)
            }

            return ChatCell(
                promiseID: chatRoom.roomId,
                nickname: chatRoom.senderNickname,
                userImage: userImage,
                content: chatRoom.messageText,
                chatDate: chatRoom.timestamp
            )
        }
    }

    
}
