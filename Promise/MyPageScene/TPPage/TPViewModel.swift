import RxSwift
import UIKit
import Foundation
import RxCocoa
import RxFlow

class TPViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let currentFlow: TPFlowType
    
    let leftButtonTapped = PublishRelay<Void>()
    let termButtonTapped = PublishRelay<Void>()
    let policyButtonTapped = PublishRelay<Void>()
    
    init(currentFlow: TPFlowType) {
        self.currentFlow = currentFlow
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow{
                case .AppFlow:
                    self?.steps.accept(AppStep.popView)
                case .myPageFlow:
                    self?.steps.accept(MyPageStep.popView)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        termButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow{
                case .AppFlow:
                    self?.steps.accept(AppStep.terms)
                case .myPageFlow:
                    self?.steps.accept(MyPageStep.terms)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        policyButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow{
                case .AppFlow:
                    self?.steps.accept(AppStep.policies)
                case .myPageFlow:
                    self?.steps.accept(MyPageStep.policies)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
    }

    
}
