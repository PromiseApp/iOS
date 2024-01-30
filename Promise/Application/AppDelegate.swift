import UIKit
import RxFlow
import RxKakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        RxKakaoSDK.initSDK(appKey: "874157b4510490128a52620b19f7f306")
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { (granted, error) in
            
            guard granted else {
                return
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

            if let aps = userInfo["aps"] as? [String: AnyObject], let contentAvailable = aps["content-available"] as? Int {
                if let category = aps["category"] as? String {
                    switch category {
                    case "PROMISE_REQUEST":
                        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.newPromiseRequestNotificationReceived)
                        NotificationCenter.default.post(name: Notification.Name("newPromiseRequestNotificationReceived"), object: nil)
                    case "FRIEND_REQUEST":
                        UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.newFriendRequestNotificationReceived)
                        NotificationCenter.default.post(name: Notification.Name("newFriendRequestNotificationReceived"), object: nil)
                    default:
                        break
                    }
                }
            }
        completionHandler(.newData)
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("tokenString: \(tokenString)")
        UserSession.shared.deviceToken = tokenString
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
    
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


extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("willPresent",userInfo)
        
        if let aps = userInfo["aps"] as? [String: AnyObject],
           let category = aps["category"] as? String {
            switch category {
            case "PROMISE_REQUEST":
                UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.newPromiseRequestNotificationReceived)
                NotificationCenter.default.post(name: Notification.Name("newPromiseRequestNotificationReceived"), object: nil)
            case "FRIEND_REQUEST":
                UserDefaults.standard.setValue(true, forKey: UserDefaultsKeys.newFriendRequestNotificationReceived)
                NotificationCenter.default.post(name: Notification.Name("newFriendRequestNotificationReceived"), object: nil)
            default:
                break
            }
        }
        completionHandler([.sound, .badge, .banner])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let userInfo = response.notification.request.content.userInfo
        print("didReceive",userInfo)
        
        if let aps = userInfo["aps"] as? [String: AnyObject],
           let category = aps["category"] as? String {
            
            let appState = UIApplication.shared.applicationState
            
            switch appState {
            case .active:
                print("앱이 실행 중일 때의 로직")
                handleNotification(category: category)
            case .inactive:
                print("앱이 백그라운드 상태에서 사용자가 알림을 탭했을 때의 로직")
                handleNotification(category: category)
            case .background:
                print("앱이 종료된 상태에서 사용자가 알림을 탭했을 때의 로직")
                UserDefaults.standard.set(category, forKey: UserDefaultsKeys.pushNotificationType)
            @unknown default:
                print("알 수 없는 새로운 상태")
            }
        }
    }
    
    func handleNotification(category: String) {
        switch category {
        case "PROMISE_REQUEST":
            NotificationCenter.default.post(name: Notification.Name("newPromiseRequestNotificationTapped"), object: nil)
        case "FRIEND_REQUEST":
            NotificationCenter.default.post(name: Notification.Name("newFriendRequestNotificationTapped"), object: nil)
        default:
            break
        }
    }
}
