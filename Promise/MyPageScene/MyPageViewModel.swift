import UIKit
import Moya
import RxCocoa
import RxSwift
import RxFlow
import RealmSwift
import Kingfisher

class MyPageViewModel: Stepper{
    let disposeBag = DisposeBag()
    var vwaDisposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    let checkTokenService: CheckTokenService
    let myPageService: MyPageService
    
    let infoSettingButtonTapped = PublishRelay<Void>()
    let announcementButtonTapped = PublishRelay<Void>()
    let inquiryButtonTapped = PublishRelay<Void>()
    let tpButtonTapped = PublishRelay<Void>()
    
    let emailRelay = BehaviorRelay<String>(value: "")
    let nicknameRelay = BehaviorRelay<String>(value: "")
    let userImageRelay = BehaviorRelay<UIImage?>(value: UIImage(named: "user"))
    let levelRelay = BehaviorRelay<Int>(value: 0)
    let expRelay = BehaviorRelay<Int>(value: 0)
    
    init(checkTokenService: CheckTokenService, myPageService: MyPageService){
        self.checkTokenService = checkTokenService
        self.myPageService = myPageService
        
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
        
        tpButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.termsAndPolicies)
            })
            .disposed(by: disposeBag)
        
    }
    
    func checkToken(completion: @escaping () -> Void){
        if let user = DatabaseManager.shared.fetchUser() {
            self.checkTokenService.checkToken(refreshToken: user.refreshToken)
                .subscribe(onSuccess: { [weak self] response in
                    DatabaseManager.shared.updateAccessToken(newToken: response.data.accessToken)
                    completion()
                }, onFailure: { [weak self] error in
                    if let moyaError = error as? MoyaError {
                        switch moyaError {
                        case .statusCode(let response):
                            switch response.statusCode {
                            case 400...499:
                                break
                            default:
                                self?.steps.accept(MyPageStep.networkErrorPopup)
                            }
                        default:
                            self?.steps.accept(MyPageStep.networkErrorPopup)
                        }
                    }
                })
                .disposed(by: vwaDisposeBag)
        }
    }
    
    func loadUserData(){
        self.myPageService.GetUserData()
            .subscribe(onSuccess: { [weak self] response in
                self?.emailRelay.accept(response.data.userInfo.account)
                self?.nicknameRelay.accept(response.data.userInfo.nickname)
                self?.levelRelay.accept(response.data.userInfo.level)
                self?.expRelay.accept(response.data.userInfo.exp)
                ImageDownloadManager.shared.downloadImage(urlString: response.data.userInfo.img, imageRelay: self!.userImageRelay)
            }, onFailure: { [weak self] error in
                self?.steps.accept(MyPageStep.networkErrorPopup)
            })
            .disposed(by: vwaDisposeBag)
    }
    
}
