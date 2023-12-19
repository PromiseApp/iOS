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
    
    let authService: AuthService

    let selectedImage = PublishRelay<UIImage?>()
    let emailRelay = BehaviorRelay<String>(value: "")
    let userImageRelay = BehaviorRelay<UIImage?>(value: nil)
    
    let leftButtonTapped = PublishRelay<Void>()
    let changePwButtonTapped = PublishRelay<Void>()
    let changeNicknameButtonTapped = PublishRelay<Void>()
    let goToLimitedCollectionView = PublishRelay<Void>()
    let logoutButtonTapped = PublishRelay<Void>()
    let withdrawButtonTapped = PublishRelay<Void>()
    
    
    init(authService: AuthService){
        self.authService = authService
        
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
                    .map{ _ in Void() }
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
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error clearing Realm data: \(error)")
        }
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
    
    func loadUser(){
        if let user = DatabaseManager.shared.fetchUser() {
            emailRelay.accept(user.account)
        }
        if let user = DatabaseManager.shared.fetchUser(),
           let imageBase64 = user.image,
           let imageData = Data(base64Encoded: imageBase64),
           let image = UIImage(data: imageData) {
            userImageRelay.accept(image)
        } else {
            userImageRelay.accept(UIImage(named: "user"))
        }
    }
   
}
