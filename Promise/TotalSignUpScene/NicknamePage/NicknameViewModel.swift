import Foundation
import RxCocoa
import RxSwift
import RxFlow

class NicknameViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let loginService: AuthService
    let currentFlow: FlowType
    
    let nicknameTextRelay = BehaviorRelay<String>(value: "")
    let duplicateButtonTapped = PublishRelay<Void>()
    var resetDuplicateCheckRelay = PublishRelay<Void>()
    let duplicateCheckPassed = BehaviorRelay<Bool>(value: false)
    
    let leftButtonTapped = PublishRelay<Void>()
    let nextButtonTapped = PublishRelay<Void>()
    
    var isValidNickname: Driver<Bool> {
        return nicknameTextRelay.asDriver(onErrorDriveWith: .empty())
            .map { [weak self] text in
                self?.validateNickname(text) ?? false
            }
    }
    var duplicateCheckResultDriver: Driver<Bool> {
        return duplicateCheckPassed.asDriver()
    }
    
    let serverResponseRelay = BehaviorRelay<Bool>(value: true)
    
    var isNextButtonEnabled: Driver<Bool> {
        return Driver.combineLatest(isValidNickname, duplicateCheckResultDriver)
            .map { $0 && $1 }
    }
    
    init(flowType: FlowType, loginService: AuthService){
        self.currentFlow = flowType
        self.loginService = loginService
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow {
                case .singupFlow:
                    self?.steps.accept(SignupStep.popView)
                case .findPwFlow:
                    break
                case .myPageFlow:
                    self?.steps.accept(MyPageStep.popView)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow {
                case .singupFlow:
                    self?.steps.accept(SignupStep.signup)
                case .findPwFlow:
                    break
                case .myPageFlow:
                    self?.steps.accept(MyPageStep.popView)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        duplicateButtonTapped
            .withLatestFrom(nicknameTextRelay)
            .flatMapLatest { [weak self] nickname in
                return self?.loginService.duplicateCheckNickname(nickname: nickname)
                    .asObservable()
                    .map {
                        return (nickname,!$0.data.isDuplicated)
                        
                    }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(SignupStep.networkErrorPopup)
                        return Observable.empty()
                    } ?? Observable.empty()
            }
            .subscribe(onNext: { [weak self] (nickname,isDuplicate) in
                self?.duplicateCheckPassed.accept(isDuplicate)
                if(isDuplicate){
                    UserSession.shared.nickname = nickname
                }
            })
            .disposed(by: disposeBag)
        
        resetDuplicateCheckRelay
            .subscribe(onNext: { [weak self] in
                self?.duplicateCheckPassed.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    private func validateNickname(_ text: String) -> Bool {
        let regex = "^[a-zA-Z0-9가-힣]{2,10}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: text)
    }
    
}
