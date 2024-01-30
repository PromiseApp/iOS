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
                    .flatMap { response -> Observable<Void> in
                        self.requestSuccessRelay.accept(nickname)
                        return Observable.empty()
                    }
                    .catch { [weak self] error in
                        print("friendService.requestFriend",error)
                        let (errorCode, errorMessage) = NetworkErrorHandler().handle(error: error)
                        switch errorCode {
                        case 401:
                            self?.steps.accept(MyPageStep.tokenExpirationPopup)
                        case 422:
                            self?.steps.accept(FriendStep.dismissView)
                            self?.steps.accept(FriendStep.requestNotExistFriendPopup)
                        case 423:
                            self?.steps.accept(FriendStep.dismissView)
                            self?.steps.accept(FriendStep.alreadyRequestFriendPopup)
                        default:
                            print("\(errorCode): \(errorMessage)")
                            self?.steps.accept(MyPageStep.networkErrorPopup)
                        }
                        return Observable.empty()
                    }
                
            }
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FriendStep.dismissView)
            })
            .disposed(by: disposeBag)
        
    }
}
