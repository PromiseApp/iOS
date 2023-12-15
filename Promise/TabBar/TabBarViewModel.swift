import RxSwift
import RxCocoa
import RxFlow

class TabBarViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()
    
    let stompService: StompService

    let selectedIndex = BehaviorRelay<Int>(value: 0)
    let plusButtonTapped = PublishRelay<Void>()
    
    init(stompService: StompService){
        self.stompService = stompService
        self.stompService.connectSocket()

        plusButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(TabBarStep.makePromise)
            })
            .disposed(by: disposeBag)
    }
  
}
