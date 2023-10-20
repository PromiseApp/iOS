import UIKit
import RxFlow

class SignupFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    let limitedVM = LimitedViewModel()
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? SignupStep else { return .none }
        
        switch step {
        case .emailAuth:
            return navigateToEmailAuth()
        case .confirmEmailAuth:
            return navigateToConfirmEmailAuth()
        case .nickname:
            return navigateToNickname()
        case .signup:
            return navigateToSignup()
        case .limitedCollectionView:
            return navigateToLimitedCollectionView()
        case .signupCompleted:
            return .end(forwardToParentFlowWithStep: AppStep.signupCompleted)
        case .popView:
            return popViewController()
        case .dismissView:
            return dismissViewController()
        case .inputErrorPopup:
            return presentInputErrorPopup()
        }
    }
    
    private func navigateToEmailAuth() -> FlowContributors {
        let VM = EmailAuthViewModel()
        let VC = EmailAuthViewController(emailAuthViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToConfirmEmailAuth() -> FlowContributors {
        let VM = ConfirmEmailAuthViewModel()
        let VC = ConfirmEmailAuthViewController(confirmEmailAuthViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToNickname() -> FlowContributors {
        let VM = NicknameViewModel(flowType: .singupFlow)
        let VC = NicknameViewController(nicknameViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToSignup() -> FlowContributors {
        let VM = SignupViewModel()
        let VC = SignupViewController(signupViewModel: VM, limitedViewModel: self.limitedVM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToLimitedCollectionView() -> FlowContributors {
        let VC = LimitedViewController(limitedViewModel: limitedVM)
        rootViewController.present(VC, animated: true)
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
    private func dismissViewController() -> FlowContributors {
        rootViewController.dismiss(animated: true)
        return .none
    }
    
    private func presentInputErrorPopup() -> FlowContributors {
        let VC = InputErrorPopUpViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
}
