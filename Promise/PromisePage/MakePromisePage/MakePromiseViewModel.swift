import RxSwift
import Foundation
import RxCocoa

class MakePromiseViewModel{
    var shareFriendViewModel:ShareFriendViewModel
    
    
    let titleRelay = PublishRelay<String>()
    let dateRelay = PublishRelay<(year: Int, month: Int, day: Int)>()
    
    let timeRelay = PublishRelay<(hour: Int, minute: Int)>()
    
    
        
    var selectedFriendDatas: Driver<[Friend]>
    
    
    
    let isNextButtonEnabled: Observable<Bool>
    
    init(shareFriendViewModel: ShareFriendViewModel) {
        self.shareFriendViewModel = shareFriendViewModel
        
        selectedFriendDatas = shareFriendViewModel.friendsRelay
            .asDriver()
            .map { friends in
                friends.filter { $0.isSelected }
            }
            .do(onNext: { aa in
                print(aa)
            })
        
        isNextButtonEnabled = Observable.combineLatest(dateRelay.asObservable(), timeRelay.asObservable(), titleRelay.asObservable())
            .map { date, time, title in
                print(date,time,title)
                return date != nil && time != nil && title != ""
            }
    }
    
//    func toggleSelection(at index: Int) {
//        var currentFriends = shareFriendViewModel.friendsRelay.value
//        currentFriends[index].isSelected = false
//        print(index,currentFriends[index])
//        shareFriendViewModel.friendsRelay.accept(currentFriends)
//        
//    }
    func toggleSelection(friend: Friend) {
        var currentFriends = shareFriendViewModel.friendsRelay.value
        if let index = currentFriends.firstIndex(where: { $0.name == friend.name }) {
            currentFriends.remove(at: index)
            shareFriendViewModel.friendsRelay.accept(currentFriends)
        }
    }

    
}
