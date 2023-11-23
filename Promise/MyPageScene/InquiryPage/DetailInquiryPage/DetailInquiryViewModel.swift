import RxSwift
import RxCocoa
import RxFlow

class DetailInquiryViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    var role: String
    
    let leftButtonTapped = PublishRelay<Void>()
    let uploadButtonTapped = PublishRelay<Void>()
    
    let titleRelay = BehaviorRelay<String>(value: "")
    let writerRelay = BehaviorRelay<String>(value: "")
    let contnetRelay = BehaviorRelay<String>(value: "")
    let replyRelay = BehaviorRelay<String?>(value: nil)
    
    let isMasterRelay = PublishRelay<Bool>()
    
    init(role: String, inquiryId: String){
        self.role = role
        
        isMasterRelay.accept(role == "ROLE_USER" ? false : true)
        
        let sampleData = DetailInquiry(title: "qweqweqwe", writer: "약속이", content: "sdkfklsdnfndsfjnsdfnjkdsfkjdsnfkjsdkfklsdnfndsfjnsdfnjkdsfkjdsnfkjsdkfklsdnfndsfjnsdfnjkdsfkjdsnfkjsdkfklsdnfndsfjnsdfnjkdsfkjdsnfkjsdkfklsdnfndsfjnsdfnjkdsfkjdsnfkj", reply: nil)
        
        titleRelay.accept(sampleData.title)
        writerRelay.accept("작성자 : \(sampleData.writer)")
        contnetRelay.accept(sampleData.content)
        replyRelay.accept(sampleData.reply ?? "접수하여 답변 작성중이오니 조금만 기다려주세요 :)")
        
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
