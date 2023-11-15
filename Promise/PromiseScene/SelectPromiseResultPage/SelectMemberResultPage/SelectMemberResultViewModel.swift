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
                let friends = response.data.membersInfo.map { friendData in
                    let friendImg = (friendData.img.flatMap { Data(base64Encoded: $0) }).flatMap { UIImage(data: $0) } ?? UIImage(named: "user")

                    return Friend(userImage: friendImg!,
                                         name: friendData.nickname,
                                  level: String(friendData.level), isSelected: false)
                    
                }
                self?.allFriends = friends
                self?.resultMemberRelay.accept(self?.allFriends ?? [])
            }, onFailure: { [weak self] error in
                self?.steps.accept(PromiseStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
        
    }
    
}
