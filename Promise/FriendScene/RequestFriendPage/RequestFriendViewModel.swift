import RxCocoa
import RealmSwift
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
                        self.removeFriendRequestFromRealm(requestId: requestId)
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
                var friends: [RequestFriend] = []
                let dispatchGroup = DispatchGroup()
                response.data.info.forEach { friendData in
                    var friend = RequestFriend(userImage: UIImage(named: "user")!,
                                               name: friendData.memberInfo.nickname,
                                               level: String(friendData.memberInfo.level),
                                               requesterID: friendData.requestInfo.id)
                    if let imageUrl = friendData.memberInfo.img {
                        dispatchGroup.enter()
                        ImageDownloadManager.shared.downloadImage(urlString: imageUrl) { image in
                            friend.userImage = image ?? UIImage(named: "user")!
                            friends.append(friend)
                            dispatchGroup.leave()
                        }
                    } else {
                        friends.append(friend)
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self?.allFriends = friends
                    self?.friendsRelay.accept(self?.allFriends ?? [])
                }
            }, onFailure: { [weak self] error in
                self?.steps.accept(FriendStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
    func removeFriendRequestFromRealm(requestId: String) {
        let realm = try! Realm()
        if let requestToDelete = realm.objects(RequestFriendModel.self).filter("requesterID == %@", requestId).first {
            try! realm.write {
                realm.delete(requestToDelete)
            }
        }
    }
}

