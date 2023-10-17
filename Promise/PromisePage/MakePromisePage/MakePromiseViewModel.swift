import RxSwift
import Foundation
import RxCocoa
import RxFlow

class MakePromiseViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var shareFriendViewModel:ShareFriendViewModel
    
    let leftButtonTapped = PublishRelay<Void>()
    let addFriendButtonTapped = PublishRelay<Void>()
    
    let titleRelay = PublishRelay<String>()
    let dateRelay = PublishRelay<(year: Int, month: Int, day: Int)>()
    let timeRelay = PublishRelay<(hour: Int, minute: Int)>()
    
    let isDateBeforeCurrent: Driver<Bool>
    
    var selectedFriendDatas: Driver<[Friend]>
    
    let isNextButtonEnabled: Observable<Bool>
    
    init(shareFriendViewModel: ShareFriendViewModel) {
        self.shareFriendViewModel = shareFriendViewModel
        
        isDateBeforeCurrent = Observable.combineLatest(dateRelay, timeRelay)
            .map { (selectedDate, selectedTime) in
                let calendar = Calendar.current
                let currentDate = Date()
                let selectedFullDate = calendar.date(from: DateComponents(year: selectedDate.year, month: selectedDate.month, day: selectedDate.day, hour: selectedTime.hour, minute: selectedTime.minute)) ?? currentDate
                return selectedFullDate < currentDate
            }
            .asDriver(onErrorJustReturn: false)
        
        selectedFriendDatas = shareFriendViewModel.friendsRelay
            .asDriver()
            .map { friends in
                friends.filter { $0.isSelected }
            }
        
        isNextButtonEnabled = Observable.combineLatest(isDateBeforeCurrent.asObservable(), titleRelay.asObservable(), selectedFriendDatas.asObservable())
            .map { bool, title, friend in
                return !bool && title != "" && !friend.isEmpty
            }
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
        addFriendButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.selectFriend)
            })
            .disposed(by: disposeBag)
    }
    
    func toggleSelection(friend: Friend) {
        var currentFriends = shareFriendViewModel.friendsRelay.value
        if let index = currentFriends.firstIndex(where: { $0.name == friend.name }) {
            currentFriends.remove(at: index)
            shareFriendViewModel.friendsRelay.accept(currentFriends)
        }
    }

    
}
