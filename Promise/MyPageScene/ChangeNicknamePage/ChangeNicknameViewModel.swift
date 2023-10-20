import RxSwift
import RxCocoa
import RxFlow

class ChangeNicknameViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
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
    
    init(flowType: FlowType){
        self.currentFlow = flowType
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(FindPwStep.popView)
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow {
                case .findPwFlow:
                    self?.steps.accept(FindPwStep.findPwCompleted)
                case .myPageFlow:
                    self?.steps.accept(MyPageStep.popView)
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
