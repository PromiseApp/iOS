import Foundation
import RxSwift
import RxCocoa

class ConfirmEmailAuthViewModel{
    var disposeBag = DisposeBag()
    
    private let timerSubject = PublishSubject<String>()
    var timerSignal: Signal<String> {
        return timerSubject.asSignal(onErrorJustReturn: "00:00")
    }
    
    let authTextRelay = BehaviorRelay<String>(value: "")
    let serverAuthCode = BehaviorRelay<String>(value: "123456") 
    
    var isNextButtonEnabled: Observable<Bool> {
        return authTextRelay.asObservable()
            .map { $0.count == 6 && $0.allSatisfy { $0.isNumber } }
    }
    
    var isAuthCodeValid: Observable<Bool> {
        return authTextRelay.asObservable()
            .withLatestFrom(serverAuthCode.asObservable()) { authText, serverCode in
                return authText == serverCode
            }
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
