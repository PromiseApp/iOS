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
        
        withdrawButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.withdrawPopup)
            })
            .disposed(by: disposeBag)
        
    }
    
   
}
