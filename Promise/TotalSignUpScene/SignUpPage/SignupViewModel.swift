import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Photos
import PhotosUI


class SignupViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let pwTextRelay = BehaviorRelay<String>(value: "")
    let rePwTextRelay = BehaviorRelay<String>(value: "")
    let selectedImage = PublishRelay<UIImage?>()
    
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
    
    init(){
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(SignupStep.popView)
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(SignupStep.signupCompleted)
            })
            .disposed(by: disposeBag)
        
        goToLimitedCollectionView
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(SignupStep.limitedCollectionView)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func validatePassword(_ text: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[@$!%*#?&])[A-Za-z\\d@$!%*#?&]{8,16}$"
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: text)
    }
    
   
}
