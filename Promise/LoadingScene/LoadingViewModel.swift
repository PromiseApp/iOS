import RxSwift
import Foundation
import Moya
import RxCocoa
import Alamofire
import RxAlamofire
import RxFlow
import RealmSwift

class LoadingViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let authService: AuthService
    
    init(authService: AuthService){
        self.authService = authService
        
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
                        self?.steps.accept(AppStep.networkErrorPopup)
                    })
                    .disposed(by: disposeBag)
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
                    existingUser.account = account
                    existingUser.password = password
                    existingUser.level = level
                    existingUser.exp = exp
                    existingUser.role = role
                    existingUser.token = token
                    if let image = image{
                        existingUser.image = image
                    }
                    //print("existingUser:\(existingUser)")
                }
            } else {
                let newUser = User()
                //print("newUser:\(newUser)")
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
    
    func fetchUserFromRealm() -> User? {
        let realm = try! Realm()
        return realm.objects(User.self).first
    }
    
}