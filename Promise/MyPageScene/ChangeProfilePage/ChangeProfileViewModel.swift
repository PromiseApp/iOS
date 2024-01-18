import UIKit
import Moya
import KakaoSDKUser
import RealmSwift
import RxSwift
import RxCocoa
import RxFlow
import Photos
import PhotosUI


class ChangeProfileViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    let checkTokenService: CheckTokenService
    let authService: AuthService
    let myPageService: MyPageService

    let selectedImage = PublishRelay<UIImage?>()
    let emailRelay = BehaviorRelay<String>(value: "")
    let userImageRelay = BehaviorRelay<UIImage?>(value: UIImage(named: "user"))
    
    let leftButtonTapped = PublishRelay<Void>()
    let changePwButtonTapped = PublishRelay<Void>()
    let changeNicknameButtonTapped = PublishRelay<Void>()
    let goToLimitedCollectionView = PublishRelay<Void>()
    let logoutButtonTapped = PublishRelay<Void>()
    let withdrawButtonTapped = PublishRelay<Void>()
    
    
    init(checkTokenService: CheckTokenService, authService: AuthService, myPageService: MyPageService){
        self.checkTokenService = checkTokenService
        self.authService = authService
        self.myPageService = myPageService
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.popView)
            })
            .disposed(by: disposeBag)
        
        changePwButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.changePw)
            })
            .disposed(by: disposeBag)
        
        changeNicknameButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.changeNickname)
            })
            .disposed(by: disposeBag)
        
        goToLimitedCollectionView
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.limitedCollectionView)
            })
            .disposed(by: disposeBag)
        
        logoutButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.normalLogout()
            })
            .disposed(by: disposeBag)
        
        withdrawButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.withdrawPopup)
            })
            .disposed(by: disposeBag)

        selectedImage
            .flatMapLatest { [weak self] image -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.authService.changeImage(img: image)
                    .asObservable()
                    .map{ response in 
                        print(response)
                        return Void() }
                    .catch { [weak self] error in
                        print(error)
                        if let moyaError = error as? MoyaError {
                            switch moyaError {
                            case .statusCode(let response):
                                print("Status Code: \(response.statusCode)")
                                print("Response Data: \(String(data: response.data, encoding: .utf8) ?? "")")
                            default:
                                print(error)
                            }
                        }
                        self?.steps.accept(MyPageStep.networkErrorPopup)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: disposeBag)
        
    }
    
    func normalLogout(){
        do {
            let realm = try Realm()
            let users = realm.objects(User.self)
            
            try! realm.write {
                realm.delete(users)
            }
        } catch {
            print("Error clearing Realm data: \(error)")
        }
        KeychainManager.shared.deleteToken(for: "AccessToken")
        KeychainManager.shared.deleteToken(for: "RefreshToken")
        self.steps.accept(MyPageStep.logoutCompleted)
    }
    
    func kakaoLogout(){
        UserApi.shared.rx.logout()
            .subscribe(onCompleted:{
                print("logout() success.")
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func appleLogout(){
        
    }
    
    
    func loadUserData(){
        self.myPageService.GetUserData()
            .subscribe(onSuccess: { [weak self] response in
                self?.emailRelay.accept(response.data.userInfo.account)
                ImageDownloadManager.shared.downloadImage(urlString: response.data.userInfo.img, imageRelay: self!.userImageRelay)
            }, onFailure: { [weak self] error in
                self?.steps.accept(MyPageStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
   
}
