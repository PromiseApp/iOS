import RxSwift
import UIKit
import Foundation
import RxCocoa
import RxFlow

class WriteInquiryViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    var role: String
    
    let leftButtonTapped = PublishRelay<Void>()
    let uploadButtonTapped = PublishRelay<Void>()
    
    let titleRelay = PublishRelay<String>()
    let contentRelay = PublishRelay<String>()
    
    let titleLengthRelay = BehaviorRelay<Int>(value: 0)
    let contentLengthRelay = BehaviorRelay<Int>(value: 0)
    
    init(role: String) {
        self.role = role
        
        titleRelay
            .map { $0.count }
            .bind(to: titleLengthRelay)
            .disposed(by: disposeBag)
        
        contentRelay
            .map { text -> Int in
                if text == "내용을 입력하세요." {
                    return 0
                } else {
                    return text.count
                }
            }
            .bind(to: contentLengthRelay)
            .disposed(by: disposeBag)
        
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.popView)
            })
            .disposed(by: disposeBag)
        
        uploadButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.popView)
            })
            .disposed(by: disposeBag)
    }

    
}
