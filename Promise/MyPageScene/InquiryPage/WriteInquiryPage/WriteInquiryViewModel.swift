import RxSwift
import UIKit
import Foundation
import RxCocoa
import RxFlow

class WriteInquiryViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    let myPageService: MyPageService
    
    let leftButtonTapped = PublishRelay<Void>()
    let uploadButtonTapped = PublishRelay<Void>()
    
    let titleRelay = PublishRelay<String>()
    let contentRelay = PublishRelay<String>()
    
    let titleLengthRelay = BehaviorRelay<Int>(value: 0)
    let contentLengthRelay = BehaviorRelay<Int>(value: 0)
    
    init(myPageService: MyPageService) {
        self.myPageService = myPageService
        
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
            .withLatestFrom(Observable.combineLatest(titleRelay.asObservable(), contentRelay.asObservable()))
            .flatMapLatest { [weak self] (title, content) -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                
                return self.myPageService.createInquiry(author: UserSession.shared.nickname, title: title, content: content, type: "INQUIRY")
                    .asObservable()
                    .map{_ in Void() }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(MyPageStep.networkErrorPopup)
                        return Observable.empty()
                    }
                
            }
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.popView)
            })
            .disposed(by: disposeBag)
    }

    
}
