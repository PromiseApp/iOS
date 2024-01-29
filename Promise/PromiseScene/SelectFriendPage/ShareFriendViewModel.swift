import RxCocoa
import RxSwift
import UIKit
import RxFlow

class ShareFriendViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var friendService: FriendService
    
    var allFriends: [Friend] = []
    let friendsLoadedRelay = PublishRelay<Void>()
    let friendsRelay = BehaviorRelay<[Friend]>(value: [])
    var isDataLoaded = false
    
    init(friendService: FriendService){
        self.friendService = friendService
        self.loadFriendList()
    }
    
    func loadFriendList(){
        self.friendService.friendList()
            .subscribe(onSuccess: { [weak self] response in
                var receivedFriends: [Friend] = []
                let dispatchGroup = DispatchGroup()

                response.data.list.forEach { friendData in
                    var friend = Friend(userImage: UIImage(named: "user")!, name: friendData.nickname, level: friendData.level, isSelected: false)

                    if let imageUrl = friendData.img {
                        dispatchGroup.enter()
                        ImageDownloadManager.shared.downloadImage(urlString: imageUrl) { image in
                            friend.userImage = image ?? UIImage(named: "user")!
                            receivedFriends.append(friend)
                            dispatchGroup.leave()
                        }
                    } else {
                        receivedFriends.append(friend)
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self?.allFriends = receivedFriends
                    self?.friendsRelay.accept(self?.allFriends ?? [])
                    self?.friendsLoadedRelay.accept(())
                }
            }, onFailure: { [weak self] error in
                print(error)
                self?.steps.accept(FriendStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
}
