import Foundation
import RealmSwift
import RxSwift
import RxCocoa
import RxFlow

class ChangePwViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let authService: AuthService
    let currentFlow: FlowType
    
    let pwTextRelay = BehaviorRelay<String>(value: "")
    let rePwTextRelay = BehaviorRelay<String>(value: "")
    
    let leftButtonTapped = PublishRelay<Void>()
    let nextButtonTapped = PublishRelay<Void>()
    
    var isPasswordValid: Driver<Bool> {
        return pwTextRelay.asDriver()
            .map { [weak self] in self?.validatePassword($0) ?? false
            }
    }
    
    var isPasswordMatching: Driver<Bool> {
        return Driver.combineLatest(
            pwTextRelay.asDriver(),
            rePwTextRelay.asDriver()
        )
        .map { password, confirmPassword in
            if(password.isEmpty){
                return false
            }
            else{
                return password == confirmPassword
            }
        }
    }
    
    var isNextButtonEnabled: Driver<Bool> {
        return Driver.combineLatest(isPasswordValid, isPasswordMatching)
            .map { isPasswordValid, isPasswordMatching in
                return isPasswordValid && isPasswordMatching
            }
    }
    
    init(authService: AuthService, flowType: FlowType){
        self.authService = authService
        self.currentFlow = flowType
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow {
                case .singupFlow:
                    break
                case .findPwFlow:
                    self?.steps.accept(FindPwStep.popView)
                case .myPageFlow:
                    self?.steps.accept(MyPageStep.popView)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .withLatestFrom(rePwTextRelay)
            .subscribe(onNext: { [weak self] pw in
                switch self?.currentFlow {
                case .singupFlow:
                    break
                case .findPwFlow:
                    self?.authService.changePasswordInLogin(account: UserSession.shared.account, password: pw)
                        .subscribe(onSuccess: { [weak self] _ in
                            self?.steps.accept(FindPwStep.findPwCompleted)
                        }, onFailure: { [weak self] error in
                            self?.steps.accept(FindPwStep.networkErrorPopup)
                        })
                        .disposed(by: self!.disposeBag)
                case .myPageFlow:
                    self?.authService.changePassword(password: pw)
                        .subscribe(onSuccess: { [weak self] _ in
                            self?.steps.accept(MyPageStep.popView)
                        }, onFailure: { [weak self] error in
                            print("authService.changePassword",error)
                            self?.steps.accept(MyPageStep.networkErrorPopup)
                        })
                        .disposed(by: self!.disposeBag)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func validatePassword(_ text: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,16}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: text)
    }
    
}
