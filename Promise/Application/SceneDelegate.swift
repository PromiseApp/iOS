import UIKit
import Photos
import RxSwift
import RxFlow
import RealmSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var coordinator = FlowCoordinator()
    var appFlow: AppFlow!
    let loginService = AuthService()
    let disposeBag = DisposeBag()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
                
        
        
        window = UIWindow(windowScene: windowScene)
        appFlow = AppFlow()
        self.checkImageAuth()
        
        Flows.use(appFlow, when: .created) { [unowned self] root in
            self.window?.rootViewController = root
            self.window?.makeKeyAndVisible()
        }
        //coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.login))
        self.autoLogin()
        
        //print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
        
        
    }
    
    func autoLogin() {
        let isAutoLoginEnabled = UserDefaults.standard.string(forKey: UserDefaultsKeys.isAutoLoginEnabled)
        if isAutoLoginEnabled == "Y" {
            if let user = fetchEmailFromRealm() {
                self.loginService.login(account: user.account, password: user.password)
                    .subscribe(onSuccess: { [weak self] response in
                        self!.saveUser(account: response.data.userInfo.account, password: user.password , nickname: response.data.userInfo.nickname, image: response.data.userInfo.img, level: response.data.userInfo.level, exp: response.data.userInfo.exp, role: response.data.userInfo.roles.first?.name ?? "ROLE_USER", token: response.data.token)
                        self?.coordinator.coordinate(flow: self!.appFlow, with: OneStepper(withSingleStep: AppStep.tabBar))
                    }, onFailure: { [weak self] error in
                        self?.coordinator.coordinate(flow: self!.appFlow, with: OneStepper(withSingleStep: AppStep.networkErrorPopup))
                    })
                    .disposed(by: disposeBag)
            }
        }
        else{
            coordinator.coordinate(flow: appFlow, with: OneStepper(withSingleStep: AppStep.login))
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
            UserSession.shared.nickname = nickname
            UserSession.shared.role = role
            UserSession.shared.token = token
            if let image = image{
                UserSession.shared.image = image
            }
            
        }catch {
            print("An error occurred while saving the user: \(error)")
        }
    }
    
    func fetchEmailFromRealm() -> User? {
        let realm = try! Realm()
        return realm.objects(User.self).first
    }
    
    func checkImageAuth(){
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .denied:
            //print("거부")
            showSettingsAlert()
        case .limited:
            //print("선택 사진 허용")
            break
        case .authorized:
            //print("허용")
            break
        case .notDetermined, .restricted:
            //print("아직 결정하지 않은 상태")
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] (state) in
                if state == .authorized || state == .limited{
                    
                } else {
                    if let rootVC = self!.window?.rootViewController {
                        rootVC.dismiss(animated: true)
                    }
                }
            }
        default:
            break
        }
    }
    
    func showSettingsAlert() {
        let alert = UIAlertController(title: "알림", message: "사진 권한이 필요합니다. 설정에서 변경해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        if let rootVC = window?.rootViewController {
            rootVC.present(alert, animated: true, completion: nil)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

