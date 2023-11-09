import RxSwift
import Foundation
import RxCocoa
import RxFlow
import Moya

class EmailAuthViewModel: Stepper {
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let loginService: AuthService
    
    let emailTextRelay = PublishRelay<String>()
    let leftButtonTapped = PublishRelay<Void>()
    let nextButtonTapped = PublishRelay<Void>()
    
    var validationResultDriver: Driver<Bool> {
        return emailTextRelay
            .asDriver(onErrorDriveWith: .empty())
            .map { [weak self] in self?.isValidEmail($0) ?? false }
    }
    
    var serverValidationResult = PublishRelay<(String,Bool)>()
    
    init(loginService: AuthService){
        self.loginService = loginService
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(SignupStep.popView)
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .withLatestFrom(emailTextRelay)
            .flatMapLatest { [weak self] account in
                return self?.loginService.duplicateCheckAccount(account: account)
                    .asObservable()
                    .map {
                        //print($0)
                        return (account,!$0.data.isDuplicated)
                        
                    }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(SignupStep.networkErrorPopup)
                        return Observable.empty()
                    } ?? Observable.empty()
            }
            .bind(to: serverValidationResult)
            .disposed(by: disposeBag)
        
        serverValidationResult
            .subscribe(onNext: { [weak self] (account,isValid) in
                if(isValid){
                    self?.steps.accept(SignupStep.confirmEmailAuth)
                    UserSession.shared.account = account
                }
                if !isValid {
                    self?.steps.accept(SignupStep.duplicateAccountErrorPopup)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
}

