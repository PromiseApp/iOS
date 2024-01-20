import UIKit
import RxFlow

class FriendFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    let friendService = FriendService()
    let addFriendPopupViewModel = AddFriendPopupViewModel(friendService: FriendService())
    let rejectFriendSuccessViewModel = RejectFriendSuccessViewModel()
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FriendStep else { return .none }
        
        switch step {
        case .friend:
            return navigateToFriend()
        case .addFriendPopup:
            return presentToAddFriendPopup()
        case .requestFriend:
            return navigateToRequestFriend()
        case .tokenExpirationPopup:
            return navigateToTokenExpirationPopup()
        case .rejectFriendPopup(let requesterID):
            return presentToRejectFriendPopup(requesterID:  requesterID)
        case .networkErrorPopup:
            return presentNetworkErrorPopup()
        case .alreadyRequestFriendPopup:
            return presentAlreadyRequestFriendPopup()
        case .requestNotExistFriendPopup:
            return presentRequestNotExistFriendPopup()
        case .popView:
            return popViewController()
        case .dismissView:
            return dismissViewController()
        case .endFlow:
            return .end(forwardToParentFlowWithStep: AppStep.endAllFlowsCompleted)
        }
    }
    
    private func navigateToFriend() -> FlowContributors {
        let VM = FriendViewModel(friendService: friendService)
        let VC = FriendViewController(friendViewModel: VM, addFriendPopupViewModel: addFriendPopupViewModel)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func presentToAddFriendPopup() -> FlowContributors {
        let VM = addFriendPopupViewModel
        let VC = AddFriendPopupViewController(addFriendPopupViewModel: VM)
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToRequestFriend() -> FlowContributors {
        let VM = RequestFriendViewModel(friendService: friendService, rejectFriendSuccessViewModel: rejectFriendSuccessViewModel)
        let VC = RequestFriendViewController(requestFriendViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToTokenExpirationPopup() -> FlowContributors {
        let tokenExpirationFlow = TokenExpirationFlow(with: rootViewController)
        return .one(flowContributor: .contribute(withNextPresentable: tokenExpirationFlow, withNextStepper: OneStepper(withSingleStep: TokenExpirationStep.tokenExpirationPopup)))
    }
    
    private func presentToRejectFriendPopup(requesterID: String) -> FlowContributors {
        let VM = RejectFriendPopupViewModel(friendService: friendService, rejectFriendSuccessViewModel: rejectFriendSuccessViewModel, requesterID: requesterID)
        let VC = RejectFriendPopupViewController(rejectFriendPopupViewModel: VM)
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func presentNetworkErrorPopup() -> FlowContributors {
        let VC = NetworkErrorPopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
    private func presentAlreadyRequestFriendPopup() -> FlowContributors {
        let VC = AlreadyRequestFriendPopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
    private func presentRequestNotExistFriendPopup() -> FlowContributors {
        let VC = RequestNotExistFriendPopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
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

