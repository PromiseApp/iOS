import RxSwift
import RxCocoa
import RxFlow

class InquiryViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    var role: String
    
    let leftButtonTapped = PublishRelay<Void>()
    let writeButtonTapped = PublishRelay<Void>()
    let detailInquiryTapped = PublishRelay<Void>()
    
    let stateCondition: Observable<[String]> = Observable.just(["전체", "접수", "답변완료"])
    let periodCondition: Observable<[String]> = Observable.just(["전체", "3개월", "6개월", "1년"])

    let isMasterRelay = PublishRelay<Bool>()
    let inquiryRelay = BehaviorRelay<[InquiryHeader]>(value: [])
    var inquiryDriver: Driver<[InquiryHeader]>{
        return inquiryRelay.asDriver(onErrorJustReturn: [])
    }
    
    init(role: String){
        self.role = role
        
        isMasterRelay.accept(role == "ROLE_USER" ? false : true)
                
        let sampleData = [
            InquiryHeader(title: "약속이 불펺애ㅐ", date: "2023-10-09", inquiryReplyDate: nil, reply: false),
            InquiryHeader(title: "약속이 불펺애ㅐ", date: "2023-10-09", inquiryReplyDate: InquiryReplyDate(date: "2023-10-13"), reply: true),
            InquiryHeader(title: "약속이 불펺애ㅐ", date: "2023-10-09", inquiryReplyDate: nil, reply: false),
        ]
        
        inquiryRelay.accept(sampleData)
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.popView)
            })
            .disposed(by: disposeBag)
        
        writeButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.writeInquiry)
            })
            .disposed(by: disposeBag)
        
        detailInquiryTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.detailInquiry)
            })
            .disposed(by: disposeBag)
        
    }
    
}
