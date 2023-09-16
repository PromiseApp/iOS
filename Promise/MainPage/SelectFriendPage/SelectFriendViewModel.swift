import RxCocoa
import UIKit
import RxSwift

class SelectFriendViewModel{
    let disposeBag = DisposeBag()
    var allFriends: [Friend] = []
    var shareFriendViewModel: ShareFriendViewModel
    
    let nextButtonTapped = PublishRelay<Void>()
    
    var friendDatas: Driver<[Friend]> {
        return shareFriendViewModel.friendsRelay
            .asDriver()
            .map { friends in
                friends.sorted { $0.isSelected && !$1.isSelected }
            }
    }
    
    init(shareFriendViewModel: ShareFriendViewModel) {
        self.shareFriendViewModel = shareFriendViewModel
        self.allFriends = shareFriendViewModel.friendsRelay.value
        
    }
    
    func search(query: String?) {
        guard let query = query, !query.isEmpty else {
            shareFriendViewModel.friendsRelay.accept(allFriends)
            return
        }
        shareFriendViewModel.friendsRelay.accept(allFriends.filter { $0.name.contains(query) })
    }
    
    func toggleSelection(at index: Int) {
        
        var currentFriends = shareFriendViewModel.friendsRelay.value.sorted { $0.isSelected && !$1.isSelected }
        currentFriends[index].isSelected.toggle()
        shareFriendViewModel.friendsRelay.accept(currentFriends)
        allFriends = currentFriends
    }
   


    
}
