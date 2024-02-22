import RxCocoa
import UIKit
import RxSwift
import RxFlow

class SelectMemberResultViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var promiseIDViewModel: PromiseIDViewModel
    var promiseService: PromiseService
    
    var promiseId = ""
    var allFriendsRelay = BehaviorRelay<[ResultFriend]>(value: [])
    
    let leftButtonTapped = PublishRelay<Void>()
    let resultButtonTapped = PublishRelay<Void>()
    let failButtonTapped = PublishRelay<String>()
    let successButtonTapped = PublishRelay<String>()
    
    let resultMemberRelay = BehaviorRelay<[Friend]>(value: [])
    var resultMemberDriver: Driver<[Friend]>{
        return resultMemberRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    var isResultButtonEnabled: Driver<Bool> {
        return allFriendsRelay.asObservable()
            .map { friends in
                return !friends.contains { $0.isSucceed == nil }
            }
            .asDriver(onErrorJustReturn: false)
    }
    
    
    init(promiseIDViewModel: PromiseIDViewModel, promiseService: PromiseService) {
        self.promiseIDViewModel = promiseIDViewModel
        self.promiseService = promiseService
        
        self.promiseIDViewModel.promiseIdRelay
            .subscribe(onNext: { [weak self] id in
                self?.promiseId = id
                self?.loadResultMember()
            })
            .disposed(by: disposeBag)
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
        failButtonTapped
            .subscribe(onNext: { [weak self] nickname in
                let allFriends = self?.allFriendsRelay.value.map { friend -> ResultFriend in
                    if friend.nickname == nickname {
                        return ResultFriend(nickname: friend.nickname, isSucceed: "N")
                    } else {
                        return friend
                    }
                }
                self?.allFriendsRelay.accept(allFriends ?? [])
            })
            .disposed(by: disposeBag)
        
        successButtonTapped
            .subscribe(onNext: { [weak self] nickname in
                let allFriends = self?.allFriendsRelay.value.map { friend -> ResultFriend in
                    if friend.nickname == nickname {
                        return ResultFriend(nickname: friend.nickname, isSucceed: "Y")
                    } else {
                        return friend
                    }
                }
                self?.allFriendsRelay.accept(allFriends ?? [])
            })
            .disposed(by: disposeBag)
        
        resultButtonTapped
            .flatMapLatest { [weak self] () -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.promiseService.resultPromise(promiseId: self.promiseId, resultFriend: self.allFriendsRelay.value)
                    .asObservable()
                    .map{ _ in Void()}
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(PromiseStep.networkErrorPopup)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popRootView)
            })
            .disposed(by: disposeBag)
    }
    
    func loadResultMember(){
        self.promiseService.detailPromise(promiseId: self.promiseId)
            .subscribe(onSuccess: { [weak self] response in
                var receivedFriends: [Friend] = []
                let dispatchGroup = DispatchGroup()
                
                response.data.membersInfo.forEach { friendData in
                    var friend = Friend(userImage: UIImage(named: "user")!, name: friendData.nickname, level: friendData.level, isSelected: false)
                    
                    if let imageUrl = friendData.img {
                        dispatchGroup.enter()
                        ImageDownloadManager.shared.downloadImage(urlString: imageUrl) { image in
                            friend.userImage = image ?? UIImage(named: "user")!
                            receivedFriends.append(friend)
                            dispatchGroup.leave()
                        }
                    } else {
                        receivedFriends.append(friend)
                    }
                }
                
                dispatchGroup.notify(queue: .main) {
                    self?.resultMemberRelay.accept(receivedFriends)
                    let resultFriends = receivedFriends.map { ResultFriend(nickname: $0.name, isSucceed: nil) }
                    self?.allFriendsRelay.accept(resultFriends)
                }
            }, onFailure: { [weak self] error in
                self?.steps.accept(PromiseStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
        
    }
    
}
