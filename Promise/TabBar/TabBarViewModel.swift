import Foundation
import RxSwift
import RxCocoa
import RxFlow

class TabBarViewModel: Stepper {
    let steps = PublishRelay<Step>()
    let disposeBag = DisposeBag()

    let selectedIndex = BehaviorRelay<Int>(value: 0)
    let plusButtonTapped = PublishRelay<Void>()
    
    init(){
        plusButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.makePromise)
            })
            .disposed(by: disposeBag)
    }
  
}
