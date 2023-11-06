import RxCocoa
import UIKit
import RxSwift
import RxFlow

class SelectMemberResultViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    var allFriends: [Friend] = []
    var tempSelectedFriends: [Friend] = []
    
    let leftButtonTapped = PublishRelay<Void>()
    let nextButtonTapped = PublishRelay<Void>()
    
    let resultMemberRelay = BehaviorRelay<[Friend]>(value: [])
    let resultMemberDriver: Driver<[Friend]>
            
    
    
    init() {
        
        resultMemberDriver = resultMemberRelay.asDriver(onErrorDriveWith: .empty())
        
        let sampleData:[Friend] = [
            Friend(userImage: UIImage(named: "user")!, name: "qweqwe", level: "2", isSelected: true),
            Friend(userImage: UIImage(named: "user")!, name: "asd", level: "4", isSelected: true),
            Friend(userImage: UIImage(named: "user")!, name: "zxc", level: "1", isSelected: true),
            Friend(userImage: UIImage(named: "user")!, name: "fgh", level: "7", isSelected: true)
        ]
        
        resultMemberRelay.accept(sampleData)
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
        nextButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
    }
    
}
