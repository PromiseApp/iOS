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
                        if response.resultCode == "423" {
                            self.steps.accept(FriendStep.dismissView)
                            self.steps.accept(FriendStep.alreadyRequestFriendPopup)
                            return Observable.empty()
                        }
                        else if response.resultCode == "422" {
                            self.steps.accept(FriendStep.dismissView)
                            self.steps.accept(FriendStep.requestNotExistFriendPopup)
                            return Observable.empty()
                        }
                        else {
                            self.requestSuccessRelay.accept(nickname)
                            return Observable.empty()
                        }
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
