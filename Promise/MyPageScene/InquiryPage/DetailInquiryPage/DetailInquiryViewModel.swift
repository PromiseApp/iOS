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
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.popView)
            })
            .disposed(by: disposeBag)
        
    }
    
    func loadNoticeList(){
        self.myPageService.inquiryList(nickname: UserSession.shared.nickname, period: "전체", statusType: "전체")
            .subscribe(onSuccess: { [weak self] response in
                for inquiry in response.data.inquiryList{
                    if(self?.inquiryId == String(inquiry.id)){
                        self?.titleRelay.accept(inquiry.title)
                        self?.writerRelay.accept("작성자 : \(UserSession.shared.nickname)")
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
