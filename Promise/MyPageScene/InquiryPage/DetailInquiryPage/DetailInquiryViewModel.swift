import RxSwift
import RxCocoa
import RxFlow

class DetailInquiryViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let myPageService: MyPageService
    let role: String
    let inquiryId: String
    
    let leftButtonTapped = PublishRelay<Void>()
    let uploadButtonTapped = PublishRelay<Void>()
    
    let titleRelay = BehaviorRelay<String>(value: "")
    let writerRelay = BehaviorRelay<String>(value: "")
    let contentRelay = BehaviorRelay<String>(value: "")
    let replyRelay = BehaviorRelay<String?>(value: nil)
    
    let isMasterRelay = BehaviorRelay<Bool>(value: false)
    
    init(myPageService: MyPageService, role:String, inquiryId: String){
        self.myPageService = myPageService
        self.role = role
        self.inquiryId = inquiryId
        self.loadNoticeList()
        isMasterRelay.accept(role == "ROLE_USER" ? false : true)
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.popView)
            })
            .disposed(by: disposeBag)
        
        uploadButtonTapped
            .withLatestFrom(replyRelay)
            .flatMapLatest { [weak self] reply -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                print(reply)
                return self.myPageService.replyInquiry(postId: self.inquiryId, author: "관리자", title: "답변", content: reply ?? "")
                    .asObservable()
                    .map{ _ in Void() }
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
    
    func loadNoticeList(){
        var account = ""
        if let user = DatabaseManager.shared.fetchUser(){
            account = user.account
        }
        
        self.myPageService.inquiryList(account: account, period: "전체", statusType: "전체")
            .subscribe(onSuccess: { [weak self] response in
                for inquiry in response.data.inquiryList{
                    if(self?.inquiryId == String(inquiry.id)){
                        self?.titleRelay.accept(inquiry.title)
                        self?.writerRelay.accept("작성자 : \(inquiry.author)")
                        self?.contentRelay.accept(inquiry.content)
                        if(inquiry.statusType == "WAITING"){
                            self?.replyRelay.accept("접수하여 답변 작성중이오니 조금만 기다려주세요 :)")
                        }
                        else{
                            let contents = inquiry.replies.map {$0.content}.first
                            self?.replyRelay.accept(contents)
                        }
                    }
                }
            }, onFailure: { [weak self] error in
                self?.steps.accept(MyPageStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
}
