//
//  SceneDelegate.swift
//  Promise
//
//  Created by 박중선 on 2023/08/31.
//

import UIKit
import Photos

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        //let rootVC = LoginViewController(loginViewModel: LoginViewModel())
        //let rootVC = EmailAuthViewController(emailAuthViewModel: EmailAuthViewModel())
        //let rootVC = NicknameViewController(nicknameViewModel: NicknameViewModel())
        //let rootVC = SignUpViewController(signUpViewModel: SignUpViewModel())
        //let rootVC = MainViewController(mainViewModel: MainViewModel())
        //let rootVC = MakePromiseViewController(makePromiseViewModel: MakePromiseViewModel())
        let rootVC = SelectFriendViewController(selectFriendViewModel: SelectFriendViewModel())
        window?.rootViewController = UINavigationController(rootViewController: rootVC)
        window?.makeKeyAndVisible()
        
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .denied:
            print("거부")
            showSettingsAlert()
        case .limited:
            print("선택 사진 허용")
        case .authorized:
            print("허용")
            
        case .notDetermined, .restricted:
            print("아직 결정하지 않은 상태")
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

