import UIKit
import RxCocoa
import RxSwift
import RxFlow
import RealmSwift

class MyPageViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let infoSettingButtonTapped = PublishRelay<Void>()
    let announcementButtonTapped = PublishRelay<Void>()
    let inquiryButtonTapped = PublishRelay<Void>()
    
    let emailRelay = BehaviorRelay<String>(value: "")
    let nicknameRelay = BehaviorRelay<String>(value: "")
    let userImageRelay = BehaviorRelay<UIImage?>(value: nil)
    let levelRelay = BehaviorRelay<Int>(value: 0)
    let expRelay = BehaviorRelay<Int>(value: 0)
    
    init(){
        self.loadUser()
        
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
    
//    private func loadUser(){
//        let realm = try! Realm()
//        let user = realm.objects(User.self).first
//        print(user)
//        emailRelay.accept(user?.account ?? "")
//        nicknameRelay.accept(user?.nickname ?? "")
//
//        if let imageBase64 = user?.image,
//           let imageData = Data(base64Encoded: imageBase64),
//           let image = UIImage(data: imageData) {
//            userImageRelay.accept(image)
//        } else {
//            userImageRelay.accept(UIImage(named: "user"))
//        }
//    }
    
    private func loadUser(){
        emailRelay.accept(UserSession.shared.account)
        nicknameRelay.accept(UserSession.shared.nickname)
        levelRelay.accept(UserSession.shared.level)
        expRelay.accept(UserSession.shared.exp)
        
        if let imageBase64 = UserSession.shared.image,
           let imageData = Data(base64Encoded: imageBase64),
           let image = UIImage(data: imageData) {
            userImageRelay.accept(image)
        } else {
            userImageRelay.accept(UIImage(named: "user"))
        }
        print("UserSession.shared.image: \(UserSession.shared.image)")
    }
    
}
