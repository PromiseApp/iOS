import UIKit
import RxFlow

class FriendFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    let friendService = FriendService()
    let addFriendPopupViewModel = AddFriendPopupViewModel(friendService: FriendService())
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
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
        case .rejectFriendPopup:
            return presentToRejectFriendPopup()
        case .networkErrorPopup:
            return presentNetworkErrorPopup()
        case .popView:
            return popViewController()
        case .dismissView:
            return dismissViewController()
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
        let VM = RequestFriendViewModel(friendService: friendService)
        let VC = RequestFriendViewController(requestFriendViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func presentToRejectFriendPopup() -> FlowContributors {
        let VC = RejectFriendPopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
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
    
    private func dismissViewController() -> FlowContributors {
        rootViewController.dismiss(animated: false)
        return .none
    }
    
}

