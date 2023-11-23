import RxSwift
import Moya
import RxCocoa
import RxFlow

class InquiryViewModel: Stepper{
    let disposeBag = DisposeBag()
    let vwaDisposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    let myPageService: MyPageService
    var role: String
    
    let leftButtonTapped = PublishRelay<Void>()
    let writeButtonTapped = PublishRelay<Void>()
    let detailInquiryTapped = PublishRelay<String>()
    
    let stateCondition: Observable<[String]> = Observable.just(["전체", "접수", "답변완료"])
    let periodCondition: Observable<[String]> = Observable.just(["전체", "3개월", "6개월", "1년"])
    
    let stateRelay = BehaviorRelay<String>(value: "전체")
    let periodRelay = BehaviorRelay<String>(value: "전체")
    
    let isMasterRelay = BehaviorRelay<Bool>(value: false)
    let inquiryRelay = BehaviorRelay<[InquiryHeader]>(value: [])
    var inquiryDriver: Driver<[InquiryHeader]>{
        return inquiryRelay.asDriver(onErrorJustReturn: [])
    }
    
    init(myPageService: MyPageService, role: String){
        self.myPageService = myPageService
        self.role = role
        
        isMasterRelay.accept(role == "ROLE_USER" ? false : true)
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.popView)
            })
            .disposed(by: disposeBag)
        
        writeButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.writeInquiry(type: "INQUIRY"))
            })
            .disposed(by: disposeBag)
        
        detailInquiryTapped
            .subscribe(onNext: { [weak self] id in
                print(id)
                self?.steps.accept(MyPageStep.detailInquiry(inquiryId: id))
            })
            .disposed(by: disposeBag)
        
    }
    
    func loadInquiryList(){
        Observable.combineLatest(stateRelay, periodRelay)
            .flatMapLatest { [weak self] (status, period) -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                var realStatus = status
                var realPeriod = period
                if(status == "접수"){
                    realStatus = "WAITING"
                }
                else if(status == "답변완료"){
                    realStatus = "COMPLETE"
                }
                if(period == "3개월"){
                    realPeriod = "3"
                }
                else if(period == "6개월"){
                    realPeriod = "6"
                }
                else if(period == "1년"){
                    realPeriod = "12"
                }
                return self.myPageService.inquiryList(nickname: UserSession.shared.nickname, period: realPeriod, statusType: realStatus)
                    .asObservable()
                    .map{ [weak self] response in
                        let inquiryList = response.data.inquiryList.map{ inquiry in
                            let inquiryDate = String(inquiry.createdDate.prefix(8))
                            let inquiryReplyDate: InquiryReplyDate?
                            let reply: Bool
                            
                            if inquiry.replies.isEmpty {
                                reply = false
                                inquiryReplyDate = nil
                            } else {
                                reply = true
                                let modifiedDateFormatted = String(inquiry.replies.first!.modifiedDate.prefix(8))
                                inquiryReplyDate = InquiryReplyDate(date: modifiedDateFormatted)
                                
                            }
                            
                            return InquiryHeader(id: String(inquiry.id), title: inquiry.title, date: inquiryDate, inquiryReplyDate: inquiryReplyDate, reply: reply)
                        }
                        self?.inquiryRelay.accept(inquiryList)
                        return Void()
                    }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(MyPageStep.networkErrorPopup)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: vwaDisposeBag)
    }
    
}
