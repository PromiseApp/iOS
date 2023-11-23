import UIKit
import RxFlow

class ChatFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ChatStep else { return .none }
        
        switch step {
        case .chat:
            return navigateToHome()
        
        }
    }
    
    private func navigateToHome() -> FlowContributors {
        let VM = ChatViewModel()
        let VC = ChatViewController(chatViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
}

