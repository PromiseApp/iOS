import UIKit
import RxFlow

class FindPwFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
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
        case .inputErrorPopup:
            return presentInputErrorPopup()
        case .dismissView:
            return dismissViewController()
        case .popView:
            return popViewController()
        }
    }
    
    private func navigateToFindPw() -> FlowContributors {
        let VM = FindPwViewModel()
        let VC = FindPwViewController(findPwViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToConfirmEmailAuth() -> FlowContributors {
        let VM = ConfirmEmailAuthViewModel()
        let VC = ConfirmEmailAuthInFindPwViewController(confirmEmailAuthViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToChangePw() -> FlowContributors {
        let VM = ChangePwViewModel(flowType: .findPwFlow)
        let VC = ChangePwViewController(changePwViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func presentInputErrorPopup() -> FlowContributors {
        let VC = InputErrorPopUpViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
    private func dismissViewController() -> FlowContributors {
        rootViewController.dismiss(animated: true)
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
}

