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
    var allFriends: [Friend] = []
    
    let leftButtonTapped = PublishRelay<Void>()
    let failButtonTapped = PublishRelay<String>()
    let successButtonTapped = PublishRelay<String>()
    
    let requestSuccessRelay = PublishRelay<String>()
    let resultMemberRelay = BehaviorRelay<[Friend]>(value: [])
    var resultMemberDriver: Driver<[Friend]>{
        return resultMemberRelay.asDriver(onErrorDriveWith: .empty())
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
            .flatMapLatest { [weak self] nickname -> Observable<String> in
                guard let self = self else { return Observable.empty() }
                return self.promiseService.resultPromise(promiseId: self.promiseId, nickname: nickname, isSucceed: "N")
                    .asObservable()
                    .flatMap{_ in Observable.just(nickname)}
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(PromiseStep.networkErrorPopup)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] nickname in
                self?.requestSuccessRelay.accept(nickname)
            })
            .disposed(by: disposeBag)
        
        successButtonTapped
            .flatMapLatest { [weak self] nickname -> Observable<String> in
                guard let self = self else { return Observable.empty() }
                return self.promiseService.resultPromise(promiseId: self.promiseId, nickname: nickname, isSucceed: "Y")
                    .asObservable()
                    .flatMap{_ in Observable.just(nickname)}
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(PromiseStep.networkErrorPopup)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] nickname in
                self?.requestSuccessRelay.accept(nickname)
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
                    self?.allFriends = receivedFriends
                    self?.resultMemberRelay.accept(self?.allFriends ?? [])
                }
            }, onFailure: { [weak self] error in
                self?.steps.accept(PromiseStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
        
    }
    
}
