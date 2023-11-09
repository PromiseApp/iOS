import RxSwift
import RxCocoa
import RxFlow

class AnnouncementViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    var role: String
    
    let leftButtonTapped = PublishRelay<Void>()
    let writeButtonTapped = PublishRelay<Void>()
    
    let isMasterRelay = PublishRelay<Bool>()
    let announcementRelay = BehaviorRelay<[AnnouncementHeader]>(value: [])
    var announcementDriver: Driver<[AnnouncementHeader]>{
        return announcementRelay
            .asDriver(onErrorJustReturn: [])
    }
    
    init(role: String){
        self.role = role
        
        isMasterRelay.accept(role == "ROLE_USER" ? true : false)
        
        let sampleData = [
            AnnouncementHeader(title: "Sample Title", date: "2023-10-30", announcementContent: AnnouncementCell(content: "Sample ContentSample ContentSample ContentSample ContentSample ContentSample ContentSample ContentSample ContentSample ContentSample ContentSample ContentSample ContentSample Content")),
            AnnouncementHeader(title: "Sample Title", date: "2023-10-31", announcementContent: AnnouncementCell(content: "Sample ContentSample ContentSample ContentSample ContentSample ContentSample ContentSample")),
            AnnouncementHeader(title: "Sample Title", date: "2023-10-31", announcementContent: AnnouncementCell(content: "Sample Content"))
        ]
        
        announcementRelay.accept(sampleData)
        
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
        
    }
    
    func toggleSectionExpansion(at section: Int) {
        var currentAnnouncement = announcementRelay.value
        currentAnnouncement[section].isExpanded.toggle()
        announcementRelay.accept(currentAnnouncement)
    }
    
}
