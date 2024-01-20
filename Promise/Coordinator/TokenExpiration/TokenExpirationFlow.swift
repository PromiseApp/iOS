import UIKit
import RxFlow

class TokenExpirationFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? TokenExpirationStep else { return .none }
        print("TokenExpirationStep",step)
        switch step {
        case .tokenExpirationPopup:
            return presentTokenExpirationPopup()
        case .dismissView:
            return dismissViewController()
        case .endFlow:
            return .end(forwardToParentFlowWithStep: MyPageStep.logoutCompleted)
        }
    }
    
    private func presentTokenExpirationPopup() -> FlowContributors {
        let VM = TokenExpirationViewModel()
        let VC = TokenExpirationViewController(tokenExpirationViewModel: VM)
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func dismissViewController() -> FlowContributors {
        rootViewController.dismiss(animated: false)
        return .none
    }
    
}

