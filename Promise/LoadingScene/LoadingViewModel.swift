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
    
    let checkTokenService: CheckTokenService
    
    init(checkTokenService: CheckTokenService){
        self.checkTokenService = checkTokenService
        
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
            case .revoked:
                print("revoked")
            case .notFound:
                print("notFound")
                
            default:
                break
            }
        }
    }
    
    func autoLogin() {
        let isAutoLoginEnabled = UserDefaults.standard.bool(forKey: UserDefaultsKeys.isAutoLoginEnabled)
        if isAutoLoginEnabled {
            if let refreshToken = KeychainManager.shared.readToken(for: "RefreshToken") {
                self.checkTokenService.checkToken(refreshToken: refreshToken)
                    .subscribe(onSuccess: { [weak self] response in
                        KeychainManager.shared.save(token: response.data.accessToken, for: "AccessToken")
                        
                        if let pushType = UserDefaults.standard.string(forKey: "pushNotificationType") {
                            switch pushType {
                            case "PROMISE_REQUEST":
                                self?.steps.accept(AppStep.tabBarAndPromise)
                            case "FRIEND_REQUEST":
                                self?.steps.accept(AppStep.tabBarAndFriend)
                            default:
                                break
                            }
                            UserDefaults.standard.removeObject(forKey: "pushNotificationType")
                        }
                        else{
                            self?.steps.accept(AppStep.tabBar)
                        }
                    }, onFailure: { [weak self] error in
                        if let moyaError = error as? MoyaError {
                            switch moyaError {
                            case .statusCode(let response):
                                switch response.statusCode {
                                case 400...499:
                                    break
                                default:
                                    self?.steps.accept(AppStep.login)
                                }
                            default:
                                self?.steps.accept(AppStep.login)
                            }
                        }
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
    
}
