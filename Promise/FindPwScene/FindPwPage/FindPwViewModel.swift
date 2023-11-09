import Foundation
import RxCocoa
import RxSwift
import RxFlow

class FindPwViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    //let loginService: LoginService
    
    let emailTextRelay = PublishRelay<String>()
    let leftButtonTapped = PublishRelay<Void>()
    let nextButtonTapped = PublishRelay<Void>()
    
    var validationResultDriver: Driver<Bool> {
        return emailTextRelay
            .asDriver(onErrorDriveWith: .empty())
            .map { [weak self] in self?.isValidEmail($0) ?? false }
    }
    
    var serverValidationResult = PublishRelay<Bool>()
    
    init(){
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FindPwStep.popView)
            })
            .disposed(by: disposeBag)
        
        
        
        serverValidationResult
            .subscribe(onNext: {[weak self] isValid in
                if(isValid){
                    self?.steps.accept(FindPwStep.confirmEmailAuth)
                }
                if !isValid {
                    self?.steps.accept(FindPwStep.confirmEmailAuth)
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
