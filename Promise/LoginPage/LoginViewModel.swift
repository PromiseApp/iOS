import RxSwift
import Foundation
import Moya
import RxCocoa
import Alamofire
import RxAlamofire
import RxFlow
import RealmSwift

class LoginViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let authService: AuthService
    let currentFlow: TPFlowType
    
    let firstIsChecked = PublishRelay<Bool>()
    let secondIsChecked = PublishRelay<Bool>()
    
    let loginButtonTapped = PublishRelay<Void>()
    let loginPossible = PublishRelay<Void>()
    
    let signupButtonTapped = PublishRelay<Void>()
    let findPwButtonTapped = PublishRelay<Void>()
    let termButtonTapped = PublishRelay<Void>()
    let policyButtonTapped = PublishRelay<Void>()
    
    let emailTextRelay = PublishRelay<String>()
    let passwordTextRelay = PublishRelay<String>()
    
    init(authService: AuthService, currentFlow: TPFlowType){
        self.authService = authService
        self.currentFlow = currentFlow
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
                            self?.steps.accept(AppStep.networkErrorPopup)
                        }
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(AppStep.tabBar)
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
