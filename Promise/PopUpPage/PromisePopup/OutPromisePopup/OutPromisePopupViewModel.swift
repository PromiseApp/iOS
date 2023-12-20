import RxSwift
import RealmSwift
import RxCocoa
import RxFlow

class OutPromisePopupViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let promiseService: PromiseService
    var stompService: StompService
    
    let nicknameTextRelay = PublishRelay<String>()
    
    let cancelButtonTapped = PublishRelay<Void>()
    let outButtonTapped = PublishRelay<Void>()
    
    init(promiseService: PromiseService, stompService: StompService, promiseId: String) {
        self.promiseService = promiseService
        self.stompService = stompService
        
        cancelButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.dismissView)
            })
            .disposed(by: disposeBag)
        
        outButtonTapped
            .flatMapLatest { [weak self] () -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.promiseService.outPromise(promiseId: promiseId)
                    .asObservable()
                    .map{ _ in
                        self.unSubscribe(roomId: Int(promiseId)!)
                        self.deleteChatListAndRelatedChatRooms(roomId: Int(promiseId)!)
                        return Void()
                    }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(PromiseStep.networkErrorPopup)
                        return Observable.empty()
                    }

            }
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.dismissView)
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
    }
    
    func unSubscribe(roomId: Int){
        self.stompService.unSubscribeToChatRoom(promiseID: roomId)
    }
    
    func deleteChatListAndRelatedChatRooms(roomId: Int) {
        let realm = try! Realm()

        try! realm.write {
            if let chatListToDelete = realm.objects(ChatList.self).filter("roomId == %@", roomId).first {
                let relatedChatRooms = realm.objects(ChatRoom.self).filter("roomId == %@", roomId)
                realm.delete(relatedChatRooms)

                realm.delete(chatListToDelete)
            }
        }
    }
}
