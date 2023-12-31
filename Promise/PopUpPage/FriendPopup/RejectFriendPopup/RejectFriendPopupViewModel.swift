import RxSwift
import RxCocoa
import RxFlow

class RejectFriendPopupViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let friendService: FriendService
    let rejectFriendSuccessViewModel: RejectFriendSuccessViewModel
    let requesterID: String
    
    let requesterIDRelay = PublishRelay<String>()
        
    let cancelButtonTapped = PublishRelay<Void>()
    let rejectButtonTapped = PublishRelay<Void>()
    let requestSuccessRelay = PublishRelay<String>()
    
    init(friendService: FriendService, rejectFriendSuccessViewModel:RejectFriendSuccessViewModel, requesterID: String) {
        self.friendService = friendService
        self.rejectFriendSuccessViewModel = rejectFriendSuccessViewModel
        self.requesterID = requesterID
        
        requesterIDRelay.accept(requesterID)
        
        cancelButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FriendStep.dismissView)
            })
            .disposed(by: disposeBag)
        
        rejectButtonTapped
            .flatMapLatest { [weak self] () -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.friendService.requestFriendReject(requestId: self.requesterID)
                    .asObservable()
                    .map{ _ in
                        self.rejectFriendSuccessViewModel.requestSuccessRelay.accept(self.requesterID)
                        return Void()
                    }
                    .catch { [weak self] error in
                        print("friendService.requestFriendReject",error)
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
