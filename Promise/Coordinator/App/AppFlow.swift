import UIKit
import RxFlow

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .login:
            return navigateToLogin()
        case .tabBar:
            return navigateToTabBar()
        case .signup:
            return navigateToSignup()
        case .findPw:
            return navigateToFindPw()
        case .signupCompleted:
            self.rootViewController.popToRootViewController(animated: true)
            return .none
        case .findPwCompleted:
            self.rootViewController.popToRootViewController(animated: true)
            return .none
        }
    }

    private func navigateToLogin() -> FlowContributors {
        let VM = LoginViewModel()
        let VC = LoginViewController(loginViewModel: VM)
        self.rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToTabBar() -> FlowContributors {
        let VM = TabBarViewModel()
        let VC = TabBarController(tabBarViewModel: VM)
        
        let promiseNC = UINavigationController()
        promiseNC.isNavigationBarHidden = true
        let friendNC = UINavigationController()
        friendNC.isNavigationBarHidden = true

        
        let promiseFlow = PromiseFlow(with: promiseNC)
        let friendFlow = FriendFlow(with: friendNC)

        Flows.use(promiseFlow, friendFlow, when: .created) { [unowned self] (promiseVC, friendVC) in
            promiseVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), tag: 0)
            friendVC.tabBarItem = UITabBarItem(title: "친구", image: UIImage(named: "friend"), tag: 2)

            let dummyVC = UIViewController()
            dummyVC.tabBarItem.isEnabled = false
            
            VC.viewControllers = [promiseVC, dummyVC, friendVC]
            self.rootViewController.setViewControllers([VC], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: promiseFlow, withNextStepper: VM),
            .contribute(withNextPresentable: promiseFlow, withNextStepper: OneStepper(withSingleStep: PromiseStep.home)),
            .contribute(withNextPresentable: friendFlow, withNextStepper: OneStepper(withSingleStep: FriendStep.friend))
        ])
    }
    
    private func navigateToSignup() -> FlowContributors {
        let signupFlow = SignupFlow(with: rootViewController)
        return .one(flowContributor: .contribute(withNextPresentable: signupFlow, withNextStepper: OneStepper(withSingleStep: SignupStep.emailAuth)))
    }
    
    private func navigateToFindPw() -> FlowContributors {
        let findPwFlow = FindPwFlow(with: rootViewController)
        return .one(flowContributor: .contribute(withNextPresentable: findPwFlow, withNextStepper: OneStepper(withSingleStep: FindPwStep.inputEmail)))
    }
    
}