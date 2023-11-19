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
                let friends = response.data.list.map { friendData in
                    let friendImg = (friendData.img.flatMap { Data(base64Encoded: $0) }).flatMap { UIImage(data: $0) } ?? UIImage(named: "user")
                    return Friend(userImage: friendImg!, name: friendData.nickname, level: friendData.level, isSelected: false)
                }
                self?.allFriends = friends
                self?.friendsRelay.accept(self?.allFriends ?? [])
                self?.friendsLoadedRelay.accept(())
            }, onFailure: { [weak self] error in
                print(error)
                self?.steps.accept(FriendStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
}
