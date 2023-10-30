import RxSwift
import RxCocoa
import RxFlow

class AnnouncementViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let leftButtonTapped = PublishRelay<Void>()
    
    let announcementRelay = BehaviorRelay<[AnnouncementHeader]>(value: [])
    let announcementDriver: Driver<[AnnouncementHeader]>
    
    init(){
        announcementDriver = announcementRelay
            .asDriver(onErrorJustReturn: [])
        
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
        
    }
    
    func toggleSectionExpansion(at section: Int) {
        var currentAnnouncement = announcementRelay.value
        currentAnnouncement[section].isExpanded.toggle()
        announcementRelay.accept(currentAnnouncement)
    }
    
}
