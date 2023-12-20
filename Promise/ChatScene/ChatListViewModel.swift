import RxSwift
import UIKit
import RealmSwift
import RxCocoa
import RxFlow

class ChatListViewModel: Stepper{
    let disposeBag = DisposeBag()
    let vwaDisposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var stompService: StompService
    var chatService: ChatService
    
    let cellSelected = PublishRelay<Int>()
    
    let chatListRelay = BehaviorRelay<[ChatListCell]>(value: [])
    var chatListDriver: Driver<[ChatListCell]>{
        return chatListRelay.asDriver(onErrorJustReturn: [])
    }
    
    init(chatService: ChatService, stompService: StompService){
        self.chatService = chatService
        self.stompService = stompService
        
        self.stompService.messageRelay
            .subscribe(onNext: { [weak self] chatRooms in

                var currentChatListCells = self?.chatListRelay.value

                chatRooms.forEach { chatRoom in
                    if let index = currentChatListCells?.firstIndex(where: { $0.promiseID == chatRoom.roomId }) {
                        let unreadMessagesCount = self?.calculateUnreadMessages(roomId: chatRoom.roomId)
                        let messageTime = self?.extractTimeFromTimestamp(chatRoom.timestamp)

                        let updatedCell = ChatListCell(promiseID: chatRoom.roomId,
                                                       title: currentChatListCells![index].title,
                                                       promiseCnt: currentChatListCells![index].promiseCnt,
                                                       promiseDate: currentChatListCells![index].promiseDate,
                                                       messageTime: messageTime ?? "", 
                                                       unReadMessagesCnt: unreadMessagesCount ?? 0)
                        
                        currentChatListCells![index] = updatedCell
                    }
                }

                self?.chatListRelay.accept(currentChatListCells!)
            })
            .disposed(by: disposeBag)

                
        cellSelected
            .subscribe(onNext: { [weak self] promiseID in
                self?.steps.accept(ChatStep.chatRoom(promiseId: promiseID))
            })
            .disposed(by: disposeBag)
        
    }
    
    func loadChatList(){
        self.chatService.chatList()
            .subscribe(onSuccess: { [weak self] response in
                let serverRoomIds = Set(response.data.chatRoomList.map { $0.roomId })
                let chatListCells = response.data.chatRoomList.map { chatRoom -> ChatListCell in
                    let messageTime = self?.fetchLastMessageTime(roomId: chatRoom.roomId)
                    let unreadMessagesCount = self?.calculateUnreadMessages(roomId: chatRoom.roomId)
                    return ChatListCell(promiseID: chatRoom.roomId,
                                        title: chatRoom.title,
                                        promiseCnt: chatRoom.totalMember,
                                        promiseDate: chatRoom.promiseDate, 
                                        messageTime: messageTime ?? "",
                                        unReadMessagesCnt: unreadMessagesCount ?? 0)
                    
                }
                self?.chatListRelay.accept(chatListCells)
                self?.updateLocalChatRooms(serverRoomIds: serverRoomIds)
            }, onFailure: { [weak self] error in
                print(error)
                self?.steps.accept(ChatStep.networkErrorPopup)
            })
            .disposed(by: vwaDisposeBag)
    }
    
    func updateLocalChatRooms(serverRoomIds: Set<Int>) {
        let realm = try! Realm()
        let localChatLists = realm.objects(ChatList.self)
        let localChatRooms = realm.objects(ChatRoom.self)
        
        try? realm.write {
            localChatLists.forEach { chatList in
                if !serverRoomIds.contains(chatList.roomId) {
                    let relatedChatRooms = localChatRooms.filter("roomId == %@", chatList.roomId)
                    realm.delete(relatedChatRooms)
                    
                    realm.delete(chatList)
                }
            }
        }
    }
    
    func extractTimeFromTimestamp(_ timestamp: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"

        if let date = dateFormatter.date(from: timestamp) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        } else {
            return ""
        }
    }
    
    func fetchLastMessageTime(roomId: Int) -> String {
        let realm = try! Realm()
        if let lastMessage = realm.objects(ChatRoom.self)
            .filter("roomId == \(roomId)")
            .sorted(byKeyPath: "timestamp", ascending: false)
            .first {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
            
            if let date = dateFormatter.date(from: lastMessage.timestamp) {
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: date)
            }
        }
        return ""
    }
    
    func calculateUnreadMessages(roomId: Int) -> Int {
        let realm = try! Realm()
        let unreadMessages = realm.objects(ChatRoom.self)
                                   .filter("roomId == \(roomId) AND isRead == false")
        return unreadMessages.count
    }
    
}
