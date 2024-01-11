import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import AuthenticationServices
import Foundation
import RxSwift
import Moya
import RxCocoa
import RxFlow
import RealmSwift

class LoadingViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let authService: AuthService
    
    init(authService: AuthService){
        self.authService = authService
        //self.kakaoAutoLogin()
        //self.appleAutoLogin()
    }
    
    func kakaoAutoLogin(){
        if (AuthApi.hasToken()) {
            UserApi.shared.rx.accessTokenInfo()
                .subscribe(onSuccess:{ (response) in
                    print("response : \(response)")
                }, onFailure: {error in
                    if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                        //로그인 필요
                        print("토큰있지만 로그인 필요")
                    }
                    else {
                        //기타 에러
                        print("기타 에러")
                    }
                })
                .disposed(by: disposeBag)
        }
        else {
            //로그인 필요
            print("토큰없고 로그인 필요")
        }
    }
    
    func appleAutoLogin(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "") { (credentialState, error) in
            switch credentialState {
            case .authorized:
                print("authorized")
                // The Apple ID credential is valid.
            case .revoked:
                print("revoked")
            case .notFound:
                // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                print("notFound")
                
            default:
                break
            }
        }
    }
    
    func autoLogin() {
        let isAutoLoginEnabled = UserDefaults.standard.string(forKey: UserDefaultsKeys.isAutoLoginEnabled)
        if isAutoLoginEnabled == "Y" {
            if let user = fetchUserFromRealm() {
                self.authService.login(account: user.account, password: user.password)
                    .subscribe(onSuccess: { [weak self] response in
                        self!.saveUser(account: response.data.userInfo.account, password: user.password , nickname: response.data.userInfo.nickname, image: response.data.userInfo.img, level: response.data.userInfo.level, exp: response.data.userInfo.exp, role: response.data.userInfo.roles.first?.name ?? "ROLE_USER", token: response.data.token)
                        self?.steps.accept(AppStep.tabBar)
                    }, onFailure: { [weak self] error in
                        print("authService.login",error)
                        self?.steps.accept(AppStep.login)
                    })
                    .disposed(by: disposeBag)
            }
            else{
                self.steps.accept(AppStep.login)
            }
        }
        else{
            self.steps.accept(AppStep.login)
        }
        
    }
    
    func saveUser(account: String, password: String , nickname: String, image: String?, level: Int, exp: Int, role: String, token: String){
        do{
            
            let realm = try Realm()
            
            if let existingUser = realm.objects(User.self).filter("account == %@", account).first {
                try realm.write {
                    existingUser.password = password
                    existingUser.nickname = nickname
                    existingUser.image = image
                    existingUser.level = level
                    existingUser.exp = exp
                    existingUser.role = role
                    existingUser.accessToken = token
                }
            } else {
                let newUser = User(account: account, password: password, nickname: nickname, image: image, level: level, exp: exp, role: role, token: token)
                
                try realm.write {
                    realm.delete(realm.objects(User.self))
                    realm.add(newUser)
                }
            }
            UserSession.shared.account = account
            
        }catch {
            print("An error occurred while saving the user: \(error)")
        }
    }
    
    func fetchUserFromRealm() -> User? {
        let realm = try! Realm()
        return realm.objects(User.self).first
    }
    
}
