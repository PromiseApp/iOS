import Foundation
import RxCocoa
import RxSwift
import RxFlow

class MyPageViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let infoSettingButtonTapped = PublishRelay<Void>()
    
   
    init(){
        infoSettingButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.changeProfile)
            })
            .disposed(by: disposeBag)

    }
}
