import RxSwift
import RxCocoa
import RxFlow

class OutPromisePopupViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let promiseService: PromiseService
    
    let nicknameTextRelay = PublishRelay<String>()
    
    let cancelButtonTapped = PublishRelay<Void>()
    let outButtonTapped = PublishRelay<Void>()
    let requestSuccessRelay = PublishRelay<String>()
    
    init(promiseService: PromiseService, promiseId: String) {
        self.promiseService = promiseService
        
        cancelButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.dismissView)
            })
            .disposed(by: disposeBag)
        
        outButtonTapped
            .flatMapLatest { [weak self] () -> Observable<Void> in
                guard let self = self else { return Observable.empty() }

                return self.promiseService.outPromise(promiseId: promiseId)
                    .asObservable()
                    .map{_ in Void()}
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(PromiseStep.networkErrorPopup)
                        return Observable.empty()
                    }

            }
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.dismissView)
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
    }
}
