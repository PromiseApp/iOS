import UIKit
import RxCocoa
import RxSwift
import RxFlow
import RealmSwift

class MyPageViewModel: Stepper{
    let disposeBag = DisposeBag()
    var vwaDisposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    let myPageService: MyPageService
    
    let infoSettingButtonTapped = PublishRelay<Void>()
    let announcementButtonTapped = PublishRelay<Void>()
    let inquiryButtonTapped = PublishRelay<Void>()
    
    let emailRelay = BehaviorRelay<String>(value: "")
    let nicknameRelay = BehaviorRelay<String>(value: "")
    let userImageRelay = BehaviorRelay<UIImage?>(value: nil)
    let levelRelay = BehaviorRelay<Int>(value: 0)
    let expRelay = BehaviorRelay<Int>(value: 0)
    
    init(myPageService: MyPageService){
        self.myPageService = myPageService
        self.loadUser()
        self.loadLevelExp()
        
        infoSettingButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.changeProfile)
            })
            .disposed(by: disposeBag)
        
        announcementButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.announcement)
            })
            .disposed(by: disposeBag)
        
        inquiryButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.inquiryList)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func loadUser(){
        emailRelay.accept(UserSession.shared.account)
        nicknameRelay.accept(UserSession.shared.nickname)
        
        if let imageBase64 = UserSession.shared.image,
           let imageData = Data(base64Encoded: imageBase64),
           let image = UIImage(data: imageData) {
            userImageRelay.accept(image)
        } else {
            userImageRelay.accept(UIImage(named: "user"))
        }
    }
    
    func loadLevelExp(){
        self.myPageService.GetExp()
            .subscribe(onSuccess: { [weak self] response in
                self?.levelRelay.accept(response.data.userInfo.level)
                self?.expRelay.accept(response.data.userInfo.exp)
            }, onFailure: { [weak self] error in
                self?.steps.accept(MyPageStep.networkErrorPopup)
            })
            .disposed(by: vwaDisposeBag)
    }
    
}
