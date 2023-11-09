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
        case .selectPromiseResult:
            return navigateToSelectPromiseResult()
        case .selectMemberResult:
            return navigateToSelectMemberResult()
//        case .modifyPromise(let id, let isManager):
//            return navigateToModifyPromise(id: id, isManager: isManager)
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
    
    private func navigateToSelectPromiseResult() -> FlowContributors {
        let VM = SelectPromiseResultViewModel()
        let VC = SelectPromiseResultViewController(selectPromiseResultViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToSelectMemberResult() -> FlowContributors {
        let VM = SelectMemberResultViewModel()
        let VC = SelectMemberResultViewController(selectMemberResultViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
//    private func navigateToModifyPromise(id: String, isManager: Bool) -> FlowContributors {
//        let VM = ModifyPromiseViewModel(shareFriendViewModel: shareVM, id: id, isManager: isManager)
//        let VC = ModifyPromiseViewController(modifyPromiseViewModel: VM)
//        VC.hidesBottomBarWhenPushed = true
//        rootViewController.pushViewController(VC, animated: true)
//        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
//    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
}

