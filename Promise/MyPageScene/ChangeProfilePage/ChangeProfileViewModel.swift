import UIKit
import RxSwift
import RxCocoa
import RxFlow
import Photos
import PhotosUI


class ChangeProfileViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()

    let selectedImage = PublishRelay<UIImage?>()
    
    let leftButtonTapped = PublishRelay<Void>()
    let changePwButtonTapped = PublishRelay<Void>()
    let changeNicknameButtonTapped = PublishRelay<Void>()
    let goToLimitedCollectionView = PublishRelay<Void>()
    let logoutButtonTapped = PublishRelay<Void>()
    let withdrawButtonTapped = PublishRelay<Void>()
    
    
    init(){
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.popView)
            })
            .disposed(by: disposeBag)
        
        changePwButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.changePw)
            })
            .disposed(by: disposeBag)
        
        changeNicknameButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.changeNickname)
            })
            .disposed(by: disposeBag)
        
        goToLimitedCollectionView
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.limitedCollectionView)
            })
            .disposed(by: disposeBag)
        
        logoutButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.logoutCompleted)
            })
            .disposed(by: disposeBag)
        
        withdrawButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.withdrawPopup)
            })
            .disposed(by: disposeBag)
        
        selectedImage
            .subscribe(onNext: { [weak self] image in
                if let imageData = image?.pngData() {
                    let base64String = imageData.base64EncodedString()
                    UserSession.shared.image = base64String
                }
            })
            .disposed(by: disposeBag)
        
    }
    
   
}
