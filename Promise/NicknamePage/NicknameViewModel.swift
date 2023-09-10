import Foundation
import RxCocoa
import RxSwift

class NicknameViewModel{
    let nicknameTextRelay = BehaviorRelay<String>(value: "")
    let duplicateButtonTapped = PublishRelay<Void>()
    
    
    var isValidNickname: Driver<Bool> {
        return nicknameTextRelay.asDriver(onErrorDriveWith: .empty())
            .map { [weak self] text in
                self?.validateNickname(text) ?? false
            }
    }
    var duplicateCheckResultDriver: Driver<Bool> {
        return duplicateButtonTapped
            .withLatestFrom(nicknameTextRelay)
            .flatMapLatest { [weak self] text -> Driver<Bool> in
                guard let self = self else { return Driver.just(false) }
                return self.checkDuplicate(nickname: text)
            }
            .asDriver(onErrorDriveWith: .empty())
    }
    
    let serverResponseRelay = BehaviorRelay<Bool>(value: true)
    
    
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
