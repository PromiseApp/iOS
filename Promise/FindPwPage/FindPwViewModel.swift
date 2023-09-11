import Foundation
import RxCocoa
import RxSwift

class FindPwViewModel{
    let emailTextRelay = PublishRelay<String>()
    let nextButtonTapped = PublishRelay<Void>()
    
    var validationResultDriver: Driver<Bool> {
        return emailTextRelay
            .asDriver(onErrorDriveWith: .empty())
            .map { [weak self] in self?.isValidEmail($0) ?? false }
    }
    
    var serverValidationResult: Driver<Bool> {
        return nextButtonTapped
            .withLatestFrom(emailTextRelay)
            .flatMapLatest { [weak self] text -> Driver<Bool> in
                guard let self = self else { return Driver.just(false) }
                return self.checkDuplicate(email: text)
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    let serverResponseRelay = BehaviorRelay<Bool>(value: true)
    
    
    
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    private func checkDuplicate(email: String) -> Driver<Bool> {
        // 이 메소드에서 실제로 서버 요청을 처리하고 결과를 serverResponseRelay에 저장해야 합니다.
        // 여기에서는 단순화를 위해 serverResponseRelay의 현재 값을 반환합니다.
        return serverResponseRelay.asDriver()
    }
}
