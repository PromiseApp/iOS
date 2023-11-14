import UIKit
import RxFlow

class PromiseFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    
    let promiseService = PromiseService()
    let shareVM = ShareFriendViewModel(friendService: FriendService())
    
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? PromiseStep else { return .none }
        
        switch step {
        case .home:
            return navigateToHome()
        case .newPromise:
            return navigateToNewPromise()
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
        case .networkErrorPopup:
            return presentNetworkErrorPopup()
        case .popView:
            return popViewController()
        }
    }
    
    private func navigateToHome() -> FlowContributors {
        let VM = PromiseViewModel(promiseService: promiseService)
        let VC = PromiseViewController(promiseViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToNewPromise() -> FlowContributors {
        let VM = NewPromiseViewModel(promiseService: self.promiseService)
        let VC = NewPromiseViewController(newPromiseViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToMakePromise() -> FlowContributors {
        let VM = MakePromiseViewModel(shareFriendViewModel: self.shareVM, promiseService: self.promiseService)
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
    
    private func presentNetworkErrorPopup() -> FlowContributors {
        let VC = NetworkErrorPopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
}

