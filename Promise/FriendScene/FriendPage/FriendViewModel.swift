import RxCocoa
import UIKit
import RxSwift
import RxFlow

class FriendViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let addFriendButtonTapped = PublishRelay<Void>()
    let requestFriendButtonTapped = PublishRelay<Void>()
    
    var allFriends: [Friend] = []
    
    let friendsRelay = BehaviorRelay<[Friend]>(value: [])
    
    var friendDatas: Driver<[Friend]> {
        return friendsRelay
            .asDriver()
            .map { friends in
                friends.sorted { $0.isSelected && !$1.isSelected }
            }
    }
    
    init() {
        addFriendButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FriendStep.addFriend)
            })
            .disposed(by: disposeBag)
        
        requestFriendButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FriendStep.requestFriend)
            })
            .disposed(by: disposeBag)
        
        allFriends = [
            Friend(userImage: UIImage(named: "plus")!, name: "가", level: "1", isSelected: false),
            Friend(userImage: UIImage(named: "plus")!, name: "나", level: "1", isSelected: false),
            Friend(userImage: UIImage(named: "down")!, name: "가나", level: "3", isSelected: false),
            Friend(userImage: UIImage(named: "left")!, name: "가다", level: "12", isSelected: false),
            Friend(userImage: UIImage(named: "plus")!, name: "다", level: "5", isSelected: false),
            Friend(userImage: UIImage(named: "left")!, name: "라라", level: "1", isSelected: false),
            Friend(userImage: UIImage(named: "user")!, name: "가나다라", level: "9", isSelected: false),
            Friend(userImage: UIImage(named: "user")!, name: "나다", level: "1", isSelected: false),
            Friend(userImage: UIImage(named: "plus")!, name: "마가나", level: "1", isSelected: false)
        ]
        
        friendsRelay.accept(allFriends)
    }
    
    func search(query: String?) {
        guard let query = query, !query.isEmpty else {
            friendsRelay.accept(allFriends)
            return
        }
        friendsRelay.accept(allFriends.filter { $0.name.contains(query) })
    }
    
}
