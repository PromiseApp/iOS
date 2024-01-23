import UIKit
import RxFlow

class FindPwFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    let authService = AuthService()
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FindPwStep else { return .none }
        
        switch step {
        case .inputEmail:
            return navigateToFindPw()
        case .confirmEmailAuth:
            return navigateToConfirmEmailAuth()
        case .changePw:
            return navigateToChangePw()
        case .findPwCompleted:
            return .end(forwardToParentFlowWithStep: AppStep.findPwCompleted)
        case .noneAccountErrorPopup:
            return presentNoneAccountErrorPopUp()
        case .networkErrorPopup:
            return presentNetworkErrorPopup()
        case .dismissView:
            return dismissViewController()
        case .popView:
            return popViewController()
        }
    }
    
    private func navigateToFindPw() -> FlowContributors {
        let VM = FindPwViewModel(authService: authService)
        let VC = FindPwViewController(findPwViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToConfirmEmailAuth() -> FlowContributors {
        let VM = ConfirmEmailAuthViewModel(authService: authService)
        let VC = ConfirmEmailAuthInFindPwViewController(confirmEmailAuthViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToChangePw() -> FlowContributors {
        let VM = ChangePwViewModel(authService: authService, flowType: .findPwFlow)
        let VC = ChangePwViewController(changePwViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func presentNoneAccountErrorPopUp() -> FlowContributors {
        let VC = NoneAccountErrorPopupViewController()
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

