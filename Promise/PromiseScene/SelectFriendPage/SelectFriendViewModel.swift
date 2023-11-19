import RxCocoa
import UIKit
import RxSwift
import RxFlow

class SelectFriendViewModel: Stepper{
    let disposeBag = DisposeBag()
    var shareFriendViewModel: ShareFriendViewModel
    let steps = PublishRelay<Step>()
    
    var allFriends: [Friend] = []
    
    let leftButtonTapped = PublishRelay<Void>()
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
        //self.shareFriendViewModel.loadFriendList()
        
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
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
