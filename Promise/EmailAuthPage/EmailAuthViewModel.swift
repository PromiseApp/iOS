import RxSwift
import Foundation
import RxCocoa

class EmailAuthViewModel {
    let emailTextRelay = PublishRelay<String>()
    
    var validationResultSignal: Signal<Bool> {
        return emailTextRelay
            .asSignal(onErrorJustReturn: "")
            .map { [weak self] in self?.isValidEmail($0) ?? false }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\\.[a-zA-Z]{2,3}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}

