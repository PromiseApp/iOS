import RxSwift
import UIKit
import Foundation
import RxCocoa
import RxFlow

class ModifyPromiseViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    var shareFriendViewModel: ShareFriendViewModel
    var promiseService: PromiseService
    
    let typeRelay = BehaviorRelay<String>(value: "isManager")
    var friendList:[Friend] = []
    
    let leftButtonTapped = PublishRelay<Void>()
    let outButtonTapped = PublishRelay<Void>()
    let addFriendButtonTapped = PublishRelay<Void>()
    let deleteButtonTapped = PublishRelay<Void>()
    let modifyButtonTapped = PublishRelay<Void>()
    
    let titleRelay = PublishRelay<String>()
    let dateRelay = PublishRelay<(year: Int, month: Int, day: Int)>()
    let timeRelay = PublishRelay<(hour: Int, minute: Int)>()
    let placeRelay = PublishRelay<String>()
    let penaltyRelay = PublishRelay<String>()
    let memoRelay = PublishRelay<String>()
    let memoTextBlackRelay = PublishRelay<UIColor>()
    
    let titleLengthRelay = BehaviorRelay<Int>(value: 0)
    let placeLengthRelay = BehaviorRelay<Int>(value: 0)
    let penaltyLengthRelay = BehaviorRelay<Int>(value: 0)
    let memoLengthRelay = BehaviorRelay<Int>(value: 0)
    
    var isDateBeforeCurrent: Driver<Bool>{
        return Observable.combineLatest(dateRelay, timeRelay)
            .map { (selectedDate, selectedTime) in
                let calendar = Calendar.current
                let currentDate = Date()
                let selectedFullDate = calendar.date(from: DateComponents(year: selectedDate.year, month: selectedDate.month, day: selectedDate.day, hour: selectedTime.hour, minute: selectedTime.minute)) ?? currentDate
                return selectedFullDate < currentDate
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    var selectedFriendDatas: Driver<[Friend]>{
        return shareFriendViewModel.friendsRelay
            .asDriver()
            .map { friends in
                friends.filter { $0.isSelected }
            }
    }
    
    init(shareFriendViewModel: ShareFriendViewModel, promiseService: PromiseService, promiseId: String, type: String) {
        self.shareFriendViewModel = shareFriendViewModel
        self.promiseService = promiseService
        self.loadDetailPromise(promiseId: promiseId)
        
        shareFriendViewModel.friendsLoadedRelay
            .subscribe(onNext: { [weak self] _ in
                self?.loadDetailPromise(promiseId: promiseId)
            })
            .disposed(by: disposeBag)
        
        typeRelay.accept(type)
        
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
        
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
        outButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.outPromisePopup(promiseId: promiseId))
            })
            .disposed(by: disposeBag)
        
        addFriendButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.selectFriendForModify)
            })
            .disposed(by: disposeBag)
        
        deleteButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.deletePromisePopup(promiseId: promiseId))
            })
            .disposed(by: disposeBag)
        
        modifyButtonTapped
            .withLatestFrom(selectedFriendDatas.asObservable())
            .flatMapLatest{ [weak self] friends -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                
                let members = friends.map{ $0.name }
                let reallist = members.filter { [weak self] newFriend in
                    !(self?.friendList.contains { oldFriend in
                        oldFriend.name == newFriend
                    })!
                }
                return self.promiseService.inviteFriend(promiseId: promiseId, members: reallist)
                    .asObservable()
                    .map{ _ in Void() }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(PromiseStep.networkErrorPopup)
                        return Observable.empty()
                        
                    }
            }
            .subscribe(onNext: { _ in
                //self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
        modifyButtonTapped
            .withLatestFrom(Observable.combineLatest(titleRelay, dateRelay,timeRelay.asObservable(),placeRelay,penaltyRelay,memoRelay))
            .flatMapLatest { [weak self] (title, date, time, place, penalty, memo) -> Observable<Void> in
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
                
                let realMemo = memo == "중요한 내용을 메모해두세요" ? nil : memo
                return self.promiseService.modifyPromise(promiseId: promiseId, title: title, date: formattedDate, place: place, penalty: penalty, memo: realMemo)
                    .asObservable()
                    .map{_ in Void() }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(PromiseStep.networkErrorPopup)
                        return Observable.empty()
                        
                    }
            }
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
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
    
    func loadDetailPromise(promiseId: String){
        self.promiseService.detailPromise(promiseId: promiseId)
            .subscribe(onSuccess: { [weak self] response in
                let receivedFriends = response.data.membersInfo.map { friendData in
                    let friendImg = (friendData.img.flatMap { Data(base64Encoded: $0) }).flatMap { UIImage(data: $0) } ?? UIImage(named: "user")
                    return Friend(userImage: friendImg!, name: friendData.nickname, level: String(friendData.level), isSelected: true)
                }
                
                var updatedFriends = self?.shareFriendViewModel.allFriends
                for receivedFriend in receivedFriends {
                    if let index = updatedFriends?.firstIndex(where: { $0.name == receivedFriend.name }) {
                        updatedFriends?[index].isSelected = true
                    }
                }
                self?.friendList = updatedFriends?.filter { $0.isSelected } ?? []
                self?.shareFriendViewModel.friendsRelay.accept(updatedFriends ?? [])
                self?.titleRelay.accept(response.data.promiseInfo.title)
                
                let dateTimeComponents = response.data.promiseInfo.date.split(separator: " ")
                let dateComponents = dateTimeComponents[0].split(separator: "-")
                let timeComponents = dateTimeComponents[1].split(separator: ":")
                
                let year = Int(dateComponents[0]) ?? 0
                let month = Int(dateComponents[1]) ?? 0
                let day = Int(dateComponents[2]) ?? 0
                let hour = Int(timeComponents[0]) ?? 0
                let minute = Int(timeComponents[1]) ?? 0
                
                self?.dateRelay.accept((year: year, month: month, day: day))
                self?.timeRelay.accept((hour: hour, minute: minute))
                
                if let location = response.data.promiseInfo.location {
                    self?.placeRelay.accept(location)
                }
                if let penalty = response.data.promiseInfo.penalty {
                    self?.penaltyRelay.accept(penalty)
                }
                if let memo = response.data.promiseInfo.memo {
                    self?.memoTextBlackRelay.accept(.black)
                    self?.memoRelay.accept(memo)
                }
                
                
            }, onFailure: { [weak self] error in
                self?.steps.accept(PromiseStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
}
