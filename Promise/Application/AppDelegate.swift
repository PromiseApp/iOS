import UIKit
import RxKakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RxKakaoSDK.initSDK(appKey: "874157b4510490128a52620b19f7f306")
        
//        // 1. 푸시 center (유저에게 권한 요청 용도)
//        let center = UNUserNotificationCenter.current()
//        center.delegate = self // push처리에 대한 delegate - UNUserNotificationCenterDelegate
//        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
//        center.requestAuthorization(options: options) { (granted, error) in
//            
//            guard granted else {
//                return
//            }
//            
//            DispatchQueue.main.async {
//                // 2. APNs에 디바이스 토큰 등록
//                UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
        
        return true
    }
    
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
//        print("tokenString: \(tokenString)")
//    }
//    
//    // 실패시
//    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
//        print("Failed to register for notifications: \(error.localizedDescription)")
//    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}


//extension AppDelegate: UNUserNotificationCenterDelegate {
//    // foreground에서 시스템 푸시를 수신했을 때 해당 메소드가 호출
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//        completionHandler([.sound, .badge, .banner])
//    }
//}
