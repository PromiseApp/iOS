import RxSwift
import RxCocoa
import RxFlow

class ChatListViewModel: Stepper{
    let disposeBag = DisposeBag()
    let vwaDisposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var chatService: ChatService
    
    let cellSelected = PublishRelay<Int>()
    
    let chatListRelay = BehaviorRelay<[ChatListCell]>(value: [])
    var chatListDriver: Driver<[ChatListCell]>{
        return chatListRelay.asDriver(onErrorJustReturn: [])
    }
    
    init(chatService: ChatService){
        self.chatService = chatService
                
        cellSelected
            .subscribe(onNext: { [weak self] promiseID in
                self?.steps.accept(ChatStep.chatRoom(promiseId: promiseID))
            })
            .disposed(by: disposeBag)
        
    }
    
    func loadChatList(){
        self.chatService.chatList()
            .subscribe(onSuccess: { [weak self] response in
                let chatListCells = response.data.chatRoomList.map { chatRoom -> ChatListCell in
                    return ChatListCell(promiseID: chatRoom.roomId,
                                        title: chatRoom.title,
                                        cnt: chatRoom.totalMember,
                                        promiseDate: chatRoom.promiseDate)
                }
                self?.chatListRelay.accept(chatListCells)
            }, onFailure: { [weak self] error in
                print(error)
                self?.steps.accept(ChatStep.networkErrorPopup)
            })
            .disposed(by: vwaDisposeBag)
    }
    
}
