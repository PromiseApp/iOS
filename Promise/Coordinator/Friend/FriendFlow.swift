import UIKit
import RxFlow

class FriendFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    
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
        case .popView:
            return popViewController()
        }
    }
    
    private func navigateToFriend() -> FlowContributors {
        let VM = FriendViewModel()
        let VC = FriendViewController(friendViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func presentToAddFriendPopup() -> FlowContributors {
        let VC = AddFriendPopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
    private func navigateToRequestFriend() -> FlowContributors {
        let VM = RequestFriendViewModel()
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
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
}

