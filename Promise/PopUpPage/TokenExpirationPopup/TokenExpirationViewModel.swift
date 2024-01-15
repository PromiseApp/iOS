import RxSwift
import RealmSwift
import RxCocoa
import RxFlow

class TokenExpirationViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    let okButtonTapped = PublishRelay<Void>()
    
    init() {
        okButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(SomeStep.dismissView)
                self?.steps.accept(SomeStep.logoutCompleted)
            })
            .disposed(by: disposeBag)
        
    }
}
