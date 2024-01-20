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
                self?.steps.accept(TokenExpirationStep.dismissView)
                self?.steps.accept(TokenExpirationStep.endFlow)
            })
            .disposed(by: disposeBag)
        
    }
}
