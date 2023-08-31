import RxSwift
import RxCocoa

class LoginViewModel{
    let firstIsChecked = PublishRelay<Bool>()
    let secondIsChecked = BehaviorRelay(value: false)
}
