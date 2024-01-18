import RealmSwift
import RxSwift
import RxCocoa
import RxFlow
import Photos
import PhotosUI

class SignupViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let authService: AuthService
    
    let emailTextRelay = BehaviorRelay<String>(value: UserSession.shared.account )
    let pwTextRelay = BehaviorRelay<String>(value: "")
    let rePwTextRelay = BehaviorRelay<String>(value: "")
    let selectedImage = BehaviorRelay<UIImage?>(value: nil)
    
    let leftButtonTapped = PublishRelay<Void>()
    let nextButtonTapped = PublishRelay<Void>()
    let goToLimitedCollectionView = PublishRelay<Void>()
    
    var isPasswordValid: Driver<Bool> {
        return pwTextRelay.asDriver()
            .map { [weak self] in self?.validatePassword($0) ?? false }
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
    
    init(authService: AuthService){
        self.authService = authService
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(SignupStep.popView)
            })
            .disposed(by: disposeBag)
        
        goToLimitedCollectionView
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(SignupStep.limitedCollectionView)
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .withLatestFrom(Observable.combineLatest(pwTextRelay.asObservable(), rePwTextRelay.asObservable(),selectedImage.asObservable()))
            .flatMapLatest { [weak self] (password, confirmPassword, selectedImage) -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                if(password == confirmPassword){
                    return self.authService.signUp(account: UserSession.shared.account, password: password, nickname: UserSession.shared.nickname, img: selectedImage)
                        .asObservable()
                        .map{ response in
                            return Void()
                        }
                        .catch { [weak self] error in
                            self?.steps.accept(SignupStep.networkErrorPopup)
                            return Observable.empty()
                        }
                }
                return Observable.empty()
            }
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(SignupStep.signupCompleted)
            })
            .disposed(by: disposeBag)
        
    }
    
    
    private func validatePassword(_ text: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,16}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: text)
    }
}
