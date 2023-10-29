import UIKit
import RxFlow

class PromiseFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    let shareVM = ShareFriendViewModel()
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PromiseStep else { return .none }
        
        switch step {
        case .home:
            return navigateToHome()
        case .makePromise:
            return navigateToMakePromise()
        case .selectFriend:
            return navigateToSelectFriend()
        case .pastPromise:
            return navigateToPastPromise()
        case .popView:
            return popViewController()
        }
    }
    
    private func navigateToHome() -> FlowContributors {
        let VM = PromiseViewModel()
        let VC = PromiseViewController(promiseViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToMakePromise() -> FlowContributors {
        let VM = MakePromiseViewModel(shareFriendViewModel: self.shareVM)
        let VC = MakePromiseViewController(makePromiseViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToSelectFriend() -> FlowContributors {
        let VM = SelectFriendViewModel(shareFriendViewModel: self.shareVM)
        let VC = SelectFriendViewController(selectFriendViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToPastPromise() -> FlowContributors {
        let VM = PastPromiseViewModel()
        let VC = PastPromiseViewController(pastPromiseViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
}

