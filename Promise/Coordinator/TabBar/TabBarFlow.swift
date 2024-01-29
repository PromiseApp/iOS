import UIKit
import RxFlow

class TabBarFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    
    let promiseService = PromiseService()
    let stompService: StompService
    var shareVM: ShareFriendViewModel?
    var shareVMForModify: ShareFriendViewModel?
    var promiseFlow: PromiseFlow
    var friendFlow: FriendFlow
    
    init(with rootViewController: UINavigationController, stompService: StompService, promiseFlow: PromiseFlow, friendFlow: FriendFlow) {
        self.rootViewController = rootViewController
        self.stompService = stompService
        self.promiseFlow = promiseFlow
        self.friendFlow = friendFlow
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        if let step = step as? TabBarStep{
            switch step {
            case .makePromise:
                return navigateToMakePromise()
            case .selectFriend:
                return navigateToSelectFriend()
            case .tokenExpirationPopup:
                return navigateToTokenExpirationPopup()
            case .networkErrorPopup:
                return presentNetworkErrorPopup()
            case .popRootView:
                return popRootViewController()
            case .popView:
                return popViewController()
            case .endFlow:
                return .end(forwardToParentFlowWithStep: AppStep.endAllFlowsCompleted)
            }
        }
        else if let promiseStep = step as? PromiseStep{
            switch promiseStep{
            case .newPromise:
                if let tabBarController = rootViewController.viewControllers.first as? UITabBarController,
                   let currentNavController = tabBarController.selectedViewController as? UINavigationController {
                    if currentNavController.viewControllers.contains(where: { $0 is NewPromiseViewController }) {
                        currentNavController.popViewController(animated: false)
                        return .one(flowContributor: .contribute(withNextPresentable: promiseFlow, withNextStepper: OneStepper(withSingleStep: PromiseStep.newPromise)))
                    }
                    else{
                        return .one(flowContributor: .contribute(withNextPresentable: promiseFlow, withNextStepper: OneStepper(withSingleStep: PromiseStep.newPromise)))
                    }
                    
                }
                return .none
            default:
                return .none
            }
        }
        else if let friendStep = step as? FriendStep{
            switch friendStep{
            case .requestFriend:
                if let tabBarController = rootViewController.viewControllers.first as? UITabBarController,
                   let currentNavController = tabBarController.selectedViewController as? UINavigationController {
                    if currentNavController.viewControllers.contains(where: { $0 is RequestFriendViewController }) {
                        currentNavController.popViewController(animated: false)
                        return .one(flowContributor: .contribute(withNextPresentable: friendFlow, withNextStepper: OneStepper(withSingleStep: FriendStep.requestFriend)))
                    }
                    else{
                        return .one(flowContributor: .contribute(withNextPresentable: friendFlow, withNextStepper: OneStepper(withSingleStep: FriendStep.requestFriend)))
                    }
                    
                }
                return .none
            default:
                return .none
            }
        }
        else {
            return .none
        }
    }
    
    private func navigateToMakePromise() -> FlowContributors {
        if let tabBarController = rootViewController.viewControllers.first as? UITabBarController,
           let currentNavController = tabBarController.selectedViewController as? UINavigationController {
            self.shareVM = ShareFriendViewModel(friendService: FriendService())
            let VM = MakePromiseViewModel(shareFriendViewModel: shareVM!, promiseService: self.promiseService, stompService: self.stompService, currentFlow: .tabBarFlow)
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
    
    private func navigateToTokenExpirationPopup() -> FlowContributors {
        let tokenExpirationFlow = TokenExpirationFlow(with: rootViewController)
        return .one(flowContributor: .contribute(withNextPresentable: tokenExpirationFlow, withNextStepper: OneStepper(withSingleStep: TokenExpirationStep.tokenExpirationPopup)))
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
