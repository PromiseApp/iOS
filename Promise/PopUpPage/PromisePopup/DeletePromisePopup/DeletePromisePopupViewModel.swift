import RxSwift
import RxCocoa
import RxFlow

class DeletePromisePopupViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let promiseService: PromiseService
    
    let nicknameTextRelay = PublishRelay<String>()
    
    let cancelButtonTapped = PublishRelay<Void>()
    let deleteButtonTapped = PublishRelay<Void>()
    
    init(promiseService: PromiseService, promiseId: String) {
        self.promiseService = promiseService
        
        cancelButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.dismissView)
            })
            .disposed(by: disposeBag)
        
        deleteButtonTapped
            .flatMapLatest { [weak self] () -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.promiseService.deletePromise(promiseId: promiseId)
                    .asObservable()
                    .map{ _ in Void()}
                    .catch { [weak self] error in
                        print("promiseService.deletePromise",error)
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
