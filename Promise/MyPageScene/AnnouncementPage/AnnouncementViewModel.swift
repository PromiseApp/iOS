import RxSwift
import RxCocoa
import RxFlow

class AnnouncementViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let myPageService: MyPageService
    var role: String
    
    let leftButtonTapped = PublishRelay<Void>()
    let writeButtonTapped = PublishRelay<Void>()
    
    let isMasterRelay = BehaviorRelay<Bool>(value: false)
    let announcementRelay = BehaviorRelay<[AnnouncementHeader]>(value: [])
    var announcementDriver: Driver<[AnnouncementHeader]>{
        return announcementRelay
            .asDriver(onErrorJustReturn: [])
    }
    
    init(myPageService: MyPageService, role: String){
        self.myPageService = myPageService
        self.role = role
        self.loadNoticeList()
        
        isMasterRelay.accept(role == "ROLE_USER" ? true : false)
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.popView)
            })
            .disposed(by: disposeBag)
        
        writeButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.writeInquiry(type: "NOTICE"))
            })
            .disposed(by: disposeBag)
        
    }
    
    func toggleSectionExpansion(at section: Int) {
        var currentAnnouncement = announcementRelay.value
        currentAnnouncement[section].isExpanded.toggle()
        announcementRelay.accept(currentAnnouncement)
    }
    
    func loadNoticeList(){
        self.myPageService.noticeList()
            .subscribe(onSuccess: { [weak self] response in
                let announcements = response.data.noticeList.map { notice in
                    AnnouncementHeader(
                        title: notice.title,
                        date: String(notice.createdDate.prefix(8)),
                        announcementContent: AnnouncementCell(content: notice.content)
                    )
                }
                self?.announcementRelay.accept(announcements)
            }, onFailure: { [weak self] error in
                self?.steps.accept(MyPageStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
}
