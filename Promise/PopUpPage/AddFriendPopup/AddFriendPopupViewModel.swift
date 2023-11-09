import RxSwift
import RxCocoa
import RxFlow

class AddFriendPopupViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let friendService: FriendService
    
    let nicknameTextRelay = PublishRelay<String>()
    
    let cancelButtonTapped = PublishRelay<Void>()
    let addButtonTapped = PublishRelay<Void>()
    let requestSuccessRelay = PublishRelay<String>()
    
    init(friendService: FriendService) {
        self.friendService = friendService
        
        cancelButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FriendStep.dismissView)
            })
            .disposed(by: disposeBag)
        
        addButtonTapped
            .withLatestFrom(nicknameTextRelay)
            .flatMapLatest { [weak self] nickname -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                
                return self.friendService.requestFriend(respondent: nickname)
                    .asObservable()
                    .map{ _ in
                        self.requestSuccessRelay.accept(nickname)
                        return Void()
                    }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(FriendStep.networkErrorPopup)
                        return Observable.empty()
                    }
                
            }
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FriendStep.dismissView)
            })
            .disposed(by: disposeBag)
        
    }
}
