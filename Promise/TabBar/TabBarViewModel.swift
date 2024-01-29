import RxSwift
import Foundation
import RxCocoa
import RxFlow

class TabBarViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    let stompService: StompService

    let selectedIndex = BehaviorRelay<Int>(value: 0)
    let plusButtonTapped = PublishRelay<Void>()
    let newPromiseRequestNotificationTapped = PublishRelay<Void>()
    let newFriendRequestNotificationTapped = PublishRelay<Void>()
    
    init(stompService: StompService){
        self.stompService = stompService
        self.stompService.connectSocket()

        plusButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(TabBarStep.makePromise)
            })
            .disposed(by: disposeBag)
        
        newPromiseRequestNotificationTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.newPromise)
            })
            .disposed(by: disposeBag)
        
        newFriendRequestNotificationTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FriendStep.requestFriend)
            })
            .disposed(by: disposeBag)
    }
  
}
