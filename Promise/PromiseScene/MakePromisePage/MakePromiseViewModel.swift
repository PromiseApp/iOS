import RxSwift
import UIKit
import Foundation
import RxCocoa
import RxFlow

class MakePromiseViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    var shareFriendViewModel: ShareFriendViewModel
    var promiseService: PromiseService
    let currentFlow: PromiseFlowType
    
    let leftButtonTapped = PublishRelay<Void>()
    let addFriendButtonTapped = PublishRelay<Void>()
    let nextButtonTapped = PublishRelay<Void>()
    
    let titleRelay = PublishRelay<String>()
    let dateRelay = PublishRelay<(year: Int, month: Int, day: Int)>()
    let timeRelay = PublishRelay<(hour: Int, minute: Int)>()
    let placeRelay = PublishRelay<String>()
    let penaltyRelay = PublishRelay<String>()
    let memoRelay = PublishRelay<String>()
    
    let titleLengthRelay = BehaviorRelay<Int>(value: 0)
    let placeLengthRelay = BehaviorRelay<Int>(value: 0)
    let penaltyLengthRelay = BehaviorRelay<Int>(value: 0)
    let memoLengthRelay = BehaviorRelay<Int>(value: 0)
    
    let isDateBeforeCurrent: Driver<Bool>
    
    var selectedFriendDatas: Driver<[Friend]>
    
    let isNextButtonEnabled: Observable<Bool>
    
    init(shareFriendViewModel: ShareFriendViewModel, promiseService: PromiseService, currentFlow: PromiseFlowType) {
        self.shareFriendViewModel = shareFriendViewModel
        self.promiseService = promiseService
        self.currentFlow = currentFlow
        
        titleRelay
            .map { $0.count }
            .bind(to: titleLengthRelay)
            .disposed(by: disposeBag)
        
        placeRelay
            .map { $0.count }
            .bind(to: placeLengthRelay)
            .disposed(by: disposeBag)
        
        penaltyRelay
            .map { $0.count }
            .bind(to: penaltyLengthRelay)
            .disposed(by: disposeBag)
        
        memoRelay
            .map { text -> Int in
                if text == "중요한 내용을 메모해두세요" {
                    return 0
                } else {
                    return text.count
                }
            }
            .bind(to: memoLengthRelay)
            .disposed(by: disposeBag)
        
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
                switch self?.currentFlow{
                case .tabBarFlow:
                    self?.steps.accept(TabBarStep.popRootView)
                case .promiseFlow:
                    self?.steps.accept(PromiseStep.popView)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        addFriendButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow{
                case .tabBarFlow:
                    self?.steps.accept(TabBarStep.selectFriend)
                case .promiseFlow:
                    self?.steps.accept(PromiseStep.selectFriend)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .withLatestFrom(Observable.combineLatest(titleRelay, dateRelay,timeRelay,selectedFriendDatas.asObservable(),placeRelay,penaltyRelay,memoRelay))
            .flatMapLatest { [weak self] (title, date, time, friends, place, penalty, memo) -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                var hour = String(time.hour)
                var minute = String(time.minute)
                if(hour.count == 1){
                    hour = "0\(hour)"
                }
                if(minute.count == 1){
                    minute = "0\(minute)"
                }
                
                var month = String(date.month)
                var day = String(date.day)
                if(month.count == 1){
                    month = "0\(month)"
                }
                if(day.count == 1){
                    day = "0\(day)"
                }
                let formattedDate = "\(date.year)-\(month)-\(day) \(hour):\(minute):00"
                
                let friendNames = friends.map { $0.name }
                let realMemo = memo == "중요한 내용을 메모해두세요" ? nil : memo
               
                return self.promiseService.registerPromise(title: title, date: formattedDate, friends: friendNames, place: place, penalty: penalty, memo: realMemo)
                    .asObservable()
                    .map{ _ in Void() }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(PromiseStep.networkErrorPopup)
                        return Observable.empty()
                        
                    }
            }
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow{
                case .tabBarFlow:
                    self?.steps.accept(TabBarStep.popRootView)
                case .promiseFlow:
                    self?.steps.accept(PromiseStep.popView)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    func toggleSelection(friend: Friend) {
        var currentFriends = shareFriendViewModel.friendsRelay.value
        if let index = currentFriends.firstIndex(where: { $0.name == friend.name }) {
            currentFriends[index].isSelected = false
            shareFriendViewModel.friendsRelay.accept(currentFriends)
        }
    }
    
    
    
}
