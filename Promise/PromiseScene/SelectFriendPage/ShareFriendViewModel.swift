import RxCocoa
import RxSwift
import UIKit

class ShareFriendViewModel{
    var allFriends: [Friend] = [
        Friend(userImage: UIImage(named: "plus")!, name: "가", level: "1", isSelected: false),
        Friend(userImage: UIImage(named: "plus")!, name: "나", level: "1", isSelected: false),
        Friend(userImage: UIImage(named: "down")!, name: "가나", level: "3", isSelected: false),
        Friend(userImage: UIImage(named: "left")!, name: "가다", level: "12", isSelected: false),
        Friend(userImage: UIImage(named: "plus")!, name: "다", level: "5", isSelected: false),
        Friend(userImage: UIImage(named: "left")!, name: "라라", level: "1", isSelected: false),
        Friend(userImage: UIImage(named: "right")!, name: "가나다라", level: "9", isSelected: false),
        Friend(userImage: UIImage(named: "camera")!, name: "나다", level: "1", isSelected: false),
        Friend(userImage: UIImage(named: "plus")!, name: "마가나", level: "1", isSelected: false),
    ]
    
    let friendsRelay = BehaviorRelay<[Friend]>(value: [])
    var isDataLoaded = false
    
    init(){
        friendsRelay.accept(allFriends)
    }
    
}
