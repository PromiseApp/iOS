import RxCocoa
import UIKit
import RxSwift
import RxFlow

class SelectFriendViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    var shareFriendViewModel: ShareFriendViewModel
    let currentFlow: PromiseFlowType
    
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
    
    init(shareFriendViewModel: ShareFriendViewModel, currentFlow: PromiseFlowType) {
        self.shareFriendViewModel = shareFriendViewModel
        self.currentFlow = currentFlow
        self.allFriends = shareFriendViewModel.friendsRelay.value
        
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow{
                case .tabBarFlow:
                    self?.steps.accept(TabBarStep.popView)
                case .promiseFlow:
                    self?.steps.accept(PromiseStep.popView)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow{
                case .tabBarFlow:
                    print(111)
                    self?.steps.accept(TabBarStep.popView)
                case .promiseFlow:
                    print(222)
                    self?.steps.accept(PromiseStep.popView)
                case .none:
                    break
                }
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
