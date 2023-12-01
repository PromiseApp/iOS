import RxCocoa
import UIKit
import RxSwift
import RxFlow

class RequestFriendViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let friendService: FriendService
    let rejectFriendSuccessViewModel: RejectFriendSuccessViewModel
    
    let leftButtonTapped = PublishRelay<Void>()
    let rejectButtonTapped = PublishRelay<String>()
    let acceptButtonTapped = PublishRelay<String>()
    
    var allFriends: [RequestFriend] = []
    
    let friendsRelay = BehaviorRelay<[RequestFriend]>(value: [])
    var friendDatas: Driver<[RequestFriend]> {
        return friendsRelay.asDriver()
    }
    
    init(friendService: FriendService, rejectFriendSuccessViewModel: RejectFriendSuccessViewModel) {
        self.friendService = friendService
        self.rejectFriendSuccessViewModel = rejectFriendSuccessViewModel
                
        self.loadRequestFriendList()
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FriendStep.popView)
            })
            .disposed(by: disposeBag)
        
        rejectButtonTapped
            .subscribe(onNext: { [weak self] requesterID in
                
                self?.steps.accept(FriendStep.rejectFriendPopup(requesterID: requesterID))
            })
            .disposed(by: disposeBag)
        
        acceptButtonTapped
            .flatMapLatest { [weak self] requestId -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.friendService.requestFriendAccept(requestId: requestId)
                    .asObservable()
                    .map{_ in
                        self.rejectFriendSuccessViewModel.requestSuccessRelay.accept(requestId)
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
    
    func loadRequestFriendList(){
        self.friendService.requestFriendList()
            .subscribe(onSuccess: { [weak self] response in
                let friends = response.data.info.map { friendData in
                    let friendImg = (friendData.memberInfo.img.flatMap { Data(base64Encoded: $0) }).flatMap { UIImage(data: $0) } ?? UIImage(named: "user")
                    return RequestFriend(userImage: friendImg!,
                                         name: friendData.memberInfo.nickname,
                                         level: String(friendData.memberInfo.level), requesterID: friendData.requestInfo.id)
                    
                }
                self?.allFriends = friends
                self?.friendsRelay.accept(self?.allFriends ?? [])
            }, onFailure: { [weak self] error in
                self?.steps.accept(FriendStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
}

