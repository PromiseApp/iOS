import UIKit
import RxFlow

class TabBarFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    
    let promiseService = PromiseService()
    var shareVM: ShareFriendViewModel?
    var shareVMForModify: ShareFriendViewModel?
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TabBarStep else { return .none }
        switch step {
        case .makePromise:
            return navigateToMakePromise()
        case .selectFriend:
            return navigateToSelectFriend()
        case .networkErrorPopup:
            return presentNetworkErrorPopup()
        case .popRootView:
            return popRootViewController()
        case .popView:
            return popViewController()
        }
    }
    
    private func navigateToMakePromise() -> FlowContributors {
        if let tabBarController = rootViewController.viewControllers.first as? UITabBarController,
           let currentNavController = tabBarController.selectedViewController as? UINavigationController {
            self.shareVM = ShareFriendViewModel(friendService: FriendService())
            let VM = MakePromiseViewModel(shareFriendViewModel: shareVM!, promiseService: self.promiseService, currentFlow: .tabBarFlow)
            let VC = MakePromiseViewController(makePromiseViewModel: VM)
            VC.hidesBottomBarWhenPushed = true
            currentNavController.pushViewController(VC, animated: true)
            
            return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
        }
        return .none
    }
    
    private func navigateToSelectFriend() -> FlowContributors {
        let VM = SelectFriendViewModel(shareFriendViewModel: self.shareVM!, currentFlow: .tabBarFlow)
        let VC = SelectFriendViewController(selectFriendViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func presentNetworkErrorPopup() -> FlowContributors {
        let VC = NetworkErrorPopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
    private func popRootViewController() -> FlowContributors {
        if let tabBarController = rootViewController.viewControllers.first as? UITabBarController,
           let currentNavController = tabBarController.selectedViewController as? UINavigationController {
            print(currentNavController)
            currentNavController.popViewController(animated: true)
            
            return .none
        }
        return .none
        
    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
}
