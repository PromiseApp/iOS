import UIKit
import RxFlow

class PromiseFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    
    let promiseService = PromiseService()
    let stompService: StompService
    var shareVM: ShareFriendViewModel?
    var shareVMForModify: ShareFriendViewModel?
    let promiseIDViewModel = PromiseIDViewModel()
    
    init(with rootViewController: UINavigationController, stompService: StompService) {
        self.rootViewController = rootViewController
        self.stompService = stompService
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
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
        case .modifyPromise(let promiseId, let type):
            return navigateToModifyPromise(promiseId: promiseId, type: type)
        case .selectFriendForModify:
            return navigateToSelectFriendForModify()
        case .networkErrorPopup:
            return presentNetworkErrorPopup()
        case .errorDeletedPromisePopup:
            return presentErrorDeletedPromisePopup()
        case .deletePromisePopup(let promiseId):
            return presentDeletePromisePopup(promiseId: promiseId)
        case .outPromisePopup(let promiseId):
            return prsentOutPromisePopup(promiseId: promiseId)
        case .popView:
            return popViewController()
        case .dismissView:
            return dismissViewController()
        }
    }
    
    private func navigateToHome() -> FlowContributors {
        let VM = PromiseViewModel(promiseService: promiseService)
        let VC = PromiseViewController(promiseViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToNewPromise() -> FlowContributors {
        let VM = NewPromiseViewModel(promiseService: self.promiseService, stompService: self.stompService)
        let VC = NewPromiseViewController(newPromiseViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToMakePromise() -> FlowContributors {
        self.shareVM = ShareFriendViewModel(friendService: FriendService())
        let VM = MakePromiseViewModel(shareFriendViewModel: shareVM!, promiseService: self.promiseService, stompService: self.stompService, currentFlow: .promiseFlow)
        let VC = MakePromiseViewController(makePromiseViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
    
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToSelectFriend() -> FlowContributors {
        let VM = SelectFriendViewModel(shareFriendViewModel: self.shareVM!, currentFlow: .promiseFlow)
        let VC = SelectFriendViewController(selectFriendViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToPastPromise() -> FlowContributors {
        let VM = PastPromiseViewModel(promiseService: promiseService)
        let VC = PastPromiseViewController(pastPromiseViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToSelectPromiseResult() -> FlowContributors {
        let VM = SelectPromiseResultViewModel(promiseIDViewModel: promiseIDViewModel, promiseService: promiseService)
        let VC = SelectPromiseResultViewController(selectPromiseResultViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToSelectMemberResult() -> FlowContributors {
        let VM = SelectMemberResultViewModel(promiseIDViewModel: promiseIDViewModel, promiseService: promiseService)
        let VC = SelectMemberResultViewController(selectMemberResultViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToModifyPromise(promiseId: String, type: String) -> FlowContributors {
        self.shareVMForModify = ShareFriendViewModel(friendService: FriendService())
        let VM = ModifyPromiseViewModel(shareFriendViewModel: shareVMForModify!, promiseService: promiseService, promiseId: promiseId, type: type)
        let VC = ModifyPromiseViewController(modifyPromiseViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToSelectFriendForModify() -> FlowContributors {
        
        let VM = SelectFriendViewModel(shareFriendViewModel: self.shareVMForModify!, currentFlow: .promiseFlow)
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
    
    private func presentErrorDeletedPromisePopup() -> FlowContributors {
        let VC = ErrorDeletedPromisePopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
    private func presentDeletePromisePopup(promiseId: String) -> FlowContributors {
        let VM = DeletePromisePopupViewModel(promiseService: promiseService, promiseId: promiseId)
        let VC = DeletePromisePopupViewController(deletePromisePopupViewModel: VM)
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func prsentOutPromisePopup(promiseId: String) -> FlowContributors {
        let VM = OutPromisePopupViewModel(promiseService: promiseService, stompService: stompService, promiseId: promiseId)
        let VC = OutPromisePopupViewController(outPromisePopupViewModel: VM)
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
    private func dismissViewController() -> FlowContributors {
        rootViewController.dismiss(animated: false)
        return .none
    }
    
}

