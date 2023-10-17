import Foundation
import RxSwift
import RxCocoa
import RxFlow

class ConfirmEmailAuthViewModel: Stepper{
    var disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    private let timerSubject = PublishSubject<String>()
    var timerDriver: Driver<String> {
        return timerSubject.asDriver(onErrorJustReturn: "00:00")
    }
    let startTimerRelay = PublishRelay<Void>()
    
    let authTextRelay = BehaviorRelay<String>(value: "")
    let serverAuthCode = BehaviorRelay<String>(value: "123456")
    let leftButtonTapped = PublishRelay<Void>()
    let nextButtonTapped = PublishRelay<Void>()
    let badValue = PublishRelay<Void>()
    var isNextButtonEnabled: Driver<Bool> {
        return authTextRelay.asDriver(onErrorDriveWith: .empty())
            .map{ $0.count == 6 && $0.allSatisfy { $0.isNumber } }
            .map{ !$0 }
    }
    
    var isAuthCodeValid: Driver<Bool> {
        return authTextRelay.asDriver(onErrorDriveWith: .empty())
            .withLatestFrom(serverAuthCode.asDriver()) { authText, serverCode in
                return authText == serverCode
            }
    }
    
    init() {
        startTimer()
        
        startTimerRelay
            .subscribe(onNext: { [weak self] in
                self?.startTimer()
            })
            .disposed(by: disposeBag)
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(SignupStep.popView)
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .withLatestFrom(isAuthCodeValid)
            .subscribe(onNext: { [weak self] isValid in
                print(isValid)
                if(isValid){
                    self?.steps.accept(SignupStep.nickname)
                }
                else{
                    self?.badValue.accept(())
                }
            })
            .disposed(by: disposeBag)
            
            
    }
    
    func startTimer() {
        disposeBag = DisposeBag()
        let totalTime = 180
        Observable<Int>
            .timer(.seconds(0), period: .seconds(1), scheduler: MainScheduler.instance)
            .take(totalTime + 1)
            .map { totalTime - $0 }
            .map { seconds -> String in
                let minutes = seconds / 60
                let seconds = seconds % 60
                return String(format: "%02d:%02d", minutes, seconds)
            }
            .bind(to: timerSubject)
            .disposed(by: disposeBag)
    }
}
