import Foundation
import RxCocoa
import RxSwift
import RxFlow

class FindPwViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    let authService: AuthService
    
    let emailTextRelay = BehaviorRelay<String>(value: "")
    let leftButtonTapped = PublishRelay<Void>()
    let nextButtonTapped = PublishRelay<Void>()
    
    var validationResultDriver: Driver<Bool> {
        return emailTextRelay
            .asDriver(onErrorDriveWith: .empty())
            .map { [weak self] in self?.isValidEmail($0) ?? false }
    }
    
    var serverValidationResult = PublishRelay<Bool>()
    
    init(authService: AuthService){
        self.authService = authService
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FindPwStep.popView)
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .withLatestFrom(emailTextRelay)
            .flatMapLatest { [weak self] email -> Observable<Bool> in
                guard let self = self else { return Observable.just(false) }
                return self.authService.duplicateCheckAccount(account: email)
                    .asObservable()
                    .map { response -> Bool in
                        let isDuplicated = response.data.isDuplicated
                        return isDuplicated
                    }
                    
            }
            .subscribe(
                    onNext: { [weak self] isDuplicated in
                        if isDuplicated {
                            UserSession.shared.account = self?.emailTextRelay.value ?? ""
                            self?.steps.accept(FindPwStep.confirmEmailAuth)
                        } else {
                            self?.steps.accept(FindPwStep.noneAccountErrorPopup)
                        }
                    },
                    onError: { [weak self] error in
                        self?.steps.accept(FindPwStep.networkErrorPopup)
                    }
                )
            .disposed(by: disposeBag)
    }
    
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
}
