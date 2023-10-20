import Foundation
import RxCocoa
import RxSwift
import RxFlow

class NicknameViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
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
    
    init(flowType: FlowType){
        self.currentFlow = flowType
        
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
            .flatMapLatest { [weak self] text -> Driver<Bool> in
                guard let self = self else { return Driver.just(false) }
                
                return self.checkDuplicate(nickname: text)
            }
            .subscribe(onNext: { [weak self] isDuplicate in
                self?.duplicateCheckPassed.accept(isDuplicate)
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
    
    private func checkDuplicate(nickname: String) -> Driver<Bool> {
        // 이 메소드에서 실제로 서버 요청을 처리하고 결과를 serverResponseRelay에 저장해야 합니다.
        // 여기에서는 단순화를 위해 serverResponseRelay의 현재 값을 반환합니다.
        return serverResponseRelay.asDriver()
    }
}
