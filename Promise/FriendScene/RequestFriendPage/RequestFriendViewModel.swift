import RxCocoa
import UIKit
import RxSwift
import RxFlow

class RequestFriendViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    let friendService: FriendService
    
    let leftButtonTapped = PublishRelay<Void>()
    
    var allFriends: [Friend] = []
    
    let friendsRelay = BehaviorRelay<[Friend]>(value: [])
    
    var friendDatas: Driver<[Friend]> {
        return friendsRelay.asDriver()
    }
    
    init(friendService: FriendService) {
        self.friendService = friendService
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FriendStep.popView)
            })
            .disposed(by: disposeBag)
        
        allFriends = [
            Friend(userImage: UIImage(named: "plus")!, name: "가", level: "1", isSelected: false),
            Friend(userImage: UIImage(named: "plus")!, name: "나", level: "1", isSelected: false),
            Friend(userImage: UIImage(named: "down")!, name: "가나", level: "3", isSelected: false),
            Friend(userImage: UIImage(named: "left")!, name: "가다", level: "12", isSelected: false),
            Friend(userImage: UIImage(named: "plus")!, name: "다", level: "5", isSelected: false),
            Friend(userImage: UIImage(named: "left")!, name: "라라", level: "1", isSelected: false),
            Friend(userImage: UIImage(named: "right")!, name: "가나다라", level: "9", isSelected: false),
            Friend(userImage: UIImage(named: "camera")!, name: "나다", level: "1", isSelected: false),
            Friend(userImage: UIImage(named: "plus")!, name: "마가나", level: "1", isSelected: false)
        ]
        
        friendsRelay.accept(allFriends)
    }

    func toggleSelection(at index: Int) {
        var currentFriends = friendsRelay.value.sorted { $0.isSelected && !$1.isSelected }
        currentFriends[index].isSelected.toggle()
        friendsRelay.accept(currentFriends)
        allFriends = currentFriends
    }
    
//    func loadRequestFriendList(){
//        self.friendService.requestFriendList()
//            .subscribe(onSuccess: { [weak self] response in
//                let friends = response.data.list.map { FriendData in
//                    let friendImg = (FriendData.img.flatMap { Data(base64Encoded: $0) }).flatMap { UIImage(data: $0) } ?? UIImage(named: "user")
//                    return Friend(userImage: friendImg!, name: FriendData.nickname, level: FriendData.level, isSelected: false)
//                }
//                self?.allFriends = friends
//                self?.friendsRelay.accept(self?.allFriends ?? [])
//            }, onFailure: { [weak self] error in
//                self?.steps.accept(FriendStep.networkErrorPopup)
//            })
//            .disposed(by: disposeBag)
//    }
    
}

