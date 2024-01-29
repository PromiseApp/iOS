import RxCocoa
import UIKit
import RxSwift
import RxFlow

class FriendViewModel: Stepper{
    let disposeBag = DisposeBag()
    let vwaDisposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let friendService: FriendService
    
    let settingViewRelay = PublishRelay<Void>()
    let dataLoading = PublishRelay<Bool>()
    let addFriendButtonTapped = PublishRelay<Void>()
    let requestFriendButtonTapped = PublishRelay<Void>()
    
    var allFriends: [Friend] = []
    let friendsRelay = BehaviorRelay<[Friend]>(value: [])
    var friendDatas: Driver<[Friend]> {
        return friendsRelay.asDriver()
    }
    
    init(friendService: FriendService) {
        self.friendService = friendService
                
        addFriendButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.settingViewRelay.accept(())
                self?.steps.accept(FriendStep.addFriendPopup)
            })
            .disposed(by: disposeBag)
        
        requestFriendButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.settingViewRelay.accept(())
                self?.steps.accept(FriendStep.requestFriend)
            })
            .disposed(by: disposeBag)
        
    }
    
    func search(query: String?) {
        guard let query = query, !query.isEmpty else {
            friendsRelay.accept(allFriends)
            return
        }
        friendsRelay.accept(allFriends.filter { $0.name.contains(query) })
    }
    
    func loadFriendList(){
        self.friendService.friendList()
            .subscribe(onSuccess: { [weak self] response in
                var friends: [Friend] = []
                let dispatchGroup = DispatchGroup()
                
                response.data.list.forEach { friendData in
                    var friend = Friend(userImage: UIImage(named: "user")!, name: friendData.nickname, level: friendData.level, isSelected: false)
                    if let imageUrl = friendData.img {
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
                    self?.dataLoading.accept(true)
                }
            }, onFailure: { [weak self] error in
                print(error)
                self?.dataLoading.accept(true)
                self?.steps.accept(FriendStep.networkErrorPopup)
            })
            .disposed(by: vwaDisposeBag)
    }
    
}
