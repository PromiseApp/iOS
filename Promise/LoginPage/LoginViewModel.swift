import RxSwift
import Moya
import RxCocoa
import Alamofire
import RxAlamofire
import RxFlow
import RealmSwift

class LoginViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let loginService: AuthService
    
    let firstIsChecked = PublishRelay<Bool>()
    let secondIsChecked = BehaviorRelay(value: false)
    
    let loginButtonTapped = PublishRelay<Void>()
    let loginPossible = PublishRelay<Void>()
    
    let signupButtonTapped = PublishRelay<Void>()
    let findPwButtonTapped = PublishRelay<Void>()
    
    let emailTextRelay = PublishRelay<String>()
    let passwordTextRelay = PublishRelay<String>()
    
    init(loginService: AuthService){
        self.loginService = loginService

        loginButtonTapped
            .withLatestFrom(Observable.combineLatest(emailTextRelay.asObservable(), passwordTextRelay.asObservable()))
            .flatMapLatest { [weak self] (email, password) -> Observable<Void> in
                guard let self = self else { return Observable.empty() }
                return self.loginService.login(account: email, password: password)
                    .asObservable()
                    .map{ response in
                        print(response.data.userInfo)
                        return self.saveUser(account: response.data.userInfo.account, nickname: response.data.userInfo.nickname, image: response.data.userInfo.img, level: response.data.userInfo.level, exp: response.data.userInfo.exp, role: response.data.userInfo.roles.first?.name ?? "ROLE_USER", token: response.data.token)
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
        
    }
    
//    func saveUser(account: String, nickname: String, image: String?, level: Int, exp: Int, role: String, token: String){
//        do{
//            let realm = try Realm()
//            let user = User()
//            user.account = account
//            user.nickname = nickname
//            user.level = level
//            user.exp = exp
//            user.role = role
//            user.token = token
//
//            if let image = image{
//                user.image = image
//            }
//
//            try realm.write {
//                realm.add(user, update: .modified)
//            }
//        }catch {
//            print("An error occurred while saving the user: \(error)")
//        }
//    }
    
    func saveUser(account: String, nickname: String, image: String?, level: Int, exp: Int, role: String, token: String){
        
        UserSession.shared.account = account
        UserSession.shared.nickname = nickname
        UserSession.shared.level = level
        UserSession.shared.exp = exp
        UserSession.shared.role = role
        UserSession.shared.token = token
        
        if let image = image{
            UserSession.shared.image = image
        }
    }
    
    
}
