import RxCocoa
import UIKit
import RxSwift
import RxFlow

class FriendViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let friendService: FriendService
    
    let settingViewRelay = PublishRelay<Void>()
    
    let addFriendButtonTapped = PublishRelay<Void>()
    let requestFriendButtonTapped = PublishRelay<Void>()
    
    var allFriends: [Friend] = []
    let friendsRelay = BehaviorRelay<[Friend]>(value: [])
    var friendDatas: Driver<[Friend]> {
        return friendsRelay.asDriver()
    }
    
    init(friendService: FriendService) {
        self.friendService = friendService
        
        self.loadFriendList()
        
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
                let friends = response.data.list.map { FriendData in
                    let friendImg = (FriendData.img.flatMap { Data(base64Encoded: $0) }).flatMap { UIImage(data: $0) } ?? UIImage(named: "user")
                    return Friend(userImage: friendImg!, name: FriendData.nickname, level: FriendData.level, isSelected: false)
                }
                self?.allFriends = friends
                self?.friendsRelay.accept(self?.allFriends ?? [])
            }, onFailure: { [weak self] error in
                self?.steps.accept(FriendStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
}
