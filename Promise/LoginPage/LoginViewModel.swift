import KakaoSDKUser
import RxKakaoSDKUser
import AuthenticationServices
import Foundation
import Moya
import RxSwift
import RxCocoa
import RxFlow
import RealmSwift

class LoginViewModel: NSObject, Stepper{
    
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let authService: AuthService
    let currentFlow: TPFlowType
    
    let firstIsChecked = PublishRelay<Bool>()
    let secondIsChecked = PublishRelay<Bool>()
    let loginPossible = PublishRelay<Void>()
    
    let loginButtonTapped = PublishRelay<Void>()
    let kakaoButtonTapped = PublishRelay<Void>()
    let appleButtonTapped = PublishRelay<ASAuthorizationControllerPresentationContextProviding>()
    let signupButtonTapped = PublishRelay<Void>()
    let findPwButtonTapped = PublishRelay<Void>()
    let termButtonTapped = PublishRelay<Void>()
    let policyButtonTapped = PublishRelay<Void>()
    
    let emailTextRelay = PublishRelay<String>()
    let passwordTextRelay = PublishRelay<String>()
    
    init(authService: AuthService, currentFlow: TPFlowType){
        self.authService = authService
        self.currentFlow = currentFlow
        super.init()
        self.loadSavedEmail()
        
        loginButtonTapped
            .withLatestFrom(Observable.combineLatest(emailTextRelay.asObservable(), passwordTextRelay.asObservable()))
            .flatMapLatest { [weak self] (email, password) -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.authService.login(account: email, password: password)
                    .asObservable()
                    .map{ response in
                        return self.saveUser(account: response.data.userInfo.account,password: password , nickname: response.data.userInfo.nickname, image: response.data.userInfo.img, level: response.data.userInfo.level, exp: response.data.userInfo.exp, role: response.data.userInfo.roles.first?.name ?? "ROLE_USER", token: response.data.token)
                    }
                    .catch { [weak self] error in
                        if let moyaError = error as? MoyaError, case .statusCode(let response) = moyaError {
                            if response.statusCode == 401 {
                                self?.steps.accept(AppStep.inputErrorPopup)
                            } else {
                                self?.steps.accept(AppStep.networkErrorPopup)
                            }
                        } else {
                            print(error)
                            self?.steps.accept(AppStep.networkErrorPopup)
                        }
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(AppStep.tabBar)
            })
            .disposed(by: disposeBag)
        
        kakaoButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.kakaoLogin()
            })
            .disposed(by: disposeBag)
        
        appleButtonTapped
            .subscribe(onNext: { provider in
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = provider
                authorizationController.performRequests()
            })
            .disposed(by: disposeBag)
        
        signupButtonTapped
            .subscribe(onNext: {
                self.steps.accept(AppStep.signup)
            })
            .disposed(by: disposeBag)
        
        findPwButtonTapped
            .subscribe(onNext: {
                self.steps.accept(AppStep.findPw)
            })
            .disposed(by: disposeBag)
        
        termButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow{
                case .AppFlow:
                    self?.steps.accept(AppStep.terms)
                case .myPageFlow:
                    self?.steps.accept(MyPageStep.terms)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        policyButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow{
                case .AppFlow:
                    self?.steps.accept(AppStep.policies)
                case .myPageFlow:
                    self?.steps.accept(MyPageStep.policies)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    func kakaoLogin(){
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext:{ (oauthToken) in
                    print("loginWithKakaoTalk() success.")
                    print(oauthToken)
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        } else {
            UserApi.shared.rx.loginWithKakaoAccount()
                .subscribe(onNext:{ (oauthToken) in
                    print("loginWithKakaoAccount() success.")
                    print(oauthToken)
                }, onError: { error in
                    print(error)
                })
                .disposed(by: disposeBag)
        }
        UserApi.shared.rx.me()
            .subscribe (onSuccess:{ user in
                print("me() success.")
                
                //do something
                print("user : \(user)")
                //self.steps.accept(AppStep.tabBar)
            }, onFailure: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    func appleLogin(){
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        //authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func saveUser(account: String, password: String , nickname: String, image: String?, level: Int, exp: Int, role: String, token: String){
        do{
            
            let realm = try Realm()
            if let existingUser = realm.objects(User.self).filter("account == %@", account).first {
                try realm.write {
                    existingUser.account = account
                    existingUser.password = password
                    existingUser.level = level
                    existingUser.exp = exp
                    existingUser.role = role
                    existingUser.token = token
                    if let image = image{
                        existingUser.image = image
                    }
                }
            } else {
                let newUser = User()
                
                newUser.account = account
                newUser.password = password
                newUser.nickname = nickname
                newUser.level = level
                newUser.exp = exp
                newUser.role = role
                newUser.token = token
                if let image = image{
                    newUser.image = image
                }
                try realm.write {
                    realm.add(newUser)
                }
            }
            
            UserSession.shared.account = account
            
        }catch {
            print("An error occurred while saving the user: \(error)")
        }
    }
    
    func loadSavedEmail() {
        let isRememberEmailEnabled = UserDefaults.standard.string(forKey: UserDefaultsKeys.isRememberEmailEnabled)
        if isRememberEmailEnabled == "Y" {
            if let email = fetchEmailFromRealm() {
                emailTextRelay.accept(email)
            }
        }
    }
    
    private func fetchEmailFromRealm() -> String? {
        let realm = try! Realm()
        return realm.objects(User.self).first?.account
    }
    
}

extension LoginViewModel: ASAuthorizationControllerDelegate{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(fullName)")
            print("email: \(email)")
            
            //Move to MainPage
            //let validVC = SignValidViewController()
            //validVC.modalPresentationStyle = .fullScreen
            //present(validVC, animated: true, completion: nil)
            //self.steps.accept(AppStep.tabBar)
            
        case let passwordCredential as ASPasswordCredential:
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
