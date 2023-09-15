import RxCocoa
import UIKit
import RxSwift

class SelectFriendViewModel{
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
    
    var friendDatas: Driver<[Friend]> {
        return friendsRelay.asDriver()
    }
    
    init() {
        friendsRelay.accept(allFriends)
    }
    
    func search(query: String?) {
        guard let query = query, !query.isEmpty else {
            friendsRelay.accept(allFriends)
            return
        }
        friendsRelay.accept(allFriends.filter { $0.name.contains(query) })
    }
    
    func toggleSelection(at index: Int) {
        var currentFriends = friendsRelay.value
        currentFriends[index].isSelected.toggle()
        friendsRelay.accept(currentFriends)
        allFriends = currentFriends
    }
}
