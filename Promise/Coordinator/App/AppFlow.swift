import UIKit
import RxFlow

class AppFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    let stompService = StompService()
    let checkTokenService = CheckTokenService()
    let authService = AuthService()
    let promiseService = PromiseService()
    var shareVM: ShareFriendViewModel?
    
    var tabBarFlow: TabBarFlow!
    var promiseFlow: PromiseFlow!
    var chatFlow: ChatFlow!
    var friendFlow: FriendFlow!
    var myPageFlow: MyPageFlow!
    
    private lazy var rootViewController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        return navigationController
    }()

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else { return .none }
        switch step {
        case .loading:
            return navigateToLoading()
        case .login:
            return navigateToLogin()
        case .tabBar:
            return navigateToTabBar()
        case .tabBarAndPromise:
            return navigateTotabBarAndPromise()
        case .tabBarAndFriend:
            return navigateTotabBarAndFriend()
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
        case .terms:
            return navigateToTerms()
        case .policies:
            return navigatePolicies()
        case .networkErrorPopup:
            return presentNetworkErrorPopup()
        case .inputErrorPopup:
            return presentInputErrorPopup()
        case .popView:
            return popViewController()
        case .endAllFlows:
            return terminateAllFlows()
        case .endAllFlowsCompleted:
            return .none
        }
    }
    
    private func navigateToLoading() -> FlowContributors {
        let VM = LoadingViewModel(checkTokenService: checkTokenService)
        let VC = LoadingViewController(loadingViewModel: VM)
        self.rootViewController.setViewControllers([VC], animated: true)

        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }

    private func navigateToLogin() -> FlowContributors {
        let VM = LoginViewModel(authService: authService, currentFlow: .AppFlow)
        let VC = LoginViewController(loginViewModel: VM)
        self.rootViewController.setViewControllers([VC], animated: false)
        
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToTabBar() -> FlowContributors {
        let VM = TabBarViewModel(stompService: self.stompService)
        let VC = TabBarController(tabBarViewModel: VM)
        
        let promiseNC = UINavigationController()
        promiseNC.isNavigationBarHidden = true
        promiseNC.interactivePopGestureRecognizer?.delegate = nil
        promiseNC.interactivePopGestureRecognizer?.isEnabled = true
        let chatNC = UINavigationController()
        chatNC.isNavigationBarHidden = true
        let friendNC = UINavigationController()
        friendNC.isNavigationBarHidden = true
        let myPageNC = UINavigationController()
        myPageNC.isNavigationBarHidden = true
        
        
        self.promiseFlow = PromiseFlow(with: promiseNC, stompService: self.stompService)
        self.chatFlow = ChatFlow(with: chatNC, stompService: self.stompService)
        self.friendFlow = FriendFlow(with: friendNC)
        self.myPageFlow = MyPageFlow(with: myPageNC)
        self.tabBarFlow = TabBarFlow(with: rootViewController, stompService: self.stompService, promiseFlow: self.promiseFlow, friendFlow: self.friendFlow)
        Flows.use(promiseFlow, chatFlow, friendFlow, myPageFlow, when: .created) { [weak self] (promiseVC, chatVC, friendVC, myPageVC) in
            
            promiseVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"),tag: 0)
            chatVC.tabBarItem = UITabBarItem(title: "채팅방", image: UIImage(named: "chat")?.withRenderingMode(.alwaysOriginal),tag: 1)
            friendVC.tabBarItem = UITabBarItem(title: "친구", image: UIImage(named: "friend")?.withRenderingMode(.alwaysOriginal), tag: 3)
            myPageVC.tabBarItem = UITabBarItem(title: "사용자", image: UIImage(named: "userGrey")?.withRenderingMode(.alwaysOriginal), tag: 4)

            let dummyVC = UIViewController()
            dummyVC.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
            dummyVC.tabBarItem.isEnabled = false
            
            
            VC.viewControllers = [promiseVC, chatVC, dummyVC, friendVC, myPageVC]
            self?.rootViewController.setViewControllers([VC], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: tabBarFlow, withNextStepper: VM),
            .contribute(withNextPresentable: promiseFlow, withNextStepper: OneStepper(withSingleStep: PromiseStep.home)),
            .contribute(withNextPresentable: chatFlow, withNextStepper: OneStepper(withSingleStep: ChatStep.chatList)),
            .contribute(withNextPresentable: friendFlow, withNextStepper: OneStepper(withSingleStep: FriendStep.friend)),
            .contribute(withNextPresentable: myPageFlow, withNextStepper: OneStepper(withSingleStep: MyPageStep.myPage))
        ])
    }
    
    private func navigateTotabBarAndPromise() -> FlowContributors {
        let VM = TabBarViewModel(stompService: self.stompService)
        let VC = TabBarController(tabBarViewModel: VM)
        
        let promiseNC = UINavigationController()
        promiseNC.isNavigationBarHidden = true
        promiseNC.interactivePopGestureRecognizer?.delegate = nil
        promiseNC.interactivePopGestureRecognizer?.isEnabled = true
        let chatNC = UINavigationController()
        chatNC.isNavigationBarHidden = true
        let friendNC = UINavigationController()
        friendNC.isNavigationBarHidden = true
        let myPageNC = UINavigationController()
        myPageNC.isNavigationBarHidden = true
        
        
        self.promiseFlow = PromiseFlow(with: promiseNC, stompService: self.stompService)
        self.chatFlow = ChatFlow(with: chatNC, stompService: self.stompService)
        self.friendFlow = FriendFlow(with: friendNC)
        self.myPageFlow = MyPageFlow(with: myPageNC)
        self.tabBarFlow = TabBarFlow(with: rootViewController, stompService: self.stompService, promiseFlow: self.promiseFlow, friendFlow: self.friendFlow)
        Flows.use(promiseFlow, chatFlow, friendFlow, myPageFlow, when: .created) { [weak self] (promiseVC, chatVC, friendVC, myPageVC) in
            
            promiseVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"),tag: 0)
            chatVC.tabBarItem = UITabBarItem(title: "채팅방", image: UIImage(named: "chat")?.withRenderingMode(.alwaysOriginal),tag: 1)
            friendVC.tabBarItem = UITabBarItem(title: "친구", image: UIImage(named: "friend")?.withRenderingMode(.alwaysOriginal), tag: 3)
            myPageVC.tabBarItem = UITabBarItem(title: "사용자", image: UIImage(named: "userGrey")?.withRenderingMode(.alwaysOriginal), tag: 4)

            let dummyVC = UIViewController()
            dummyVC.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
            dummyVC.tabBarItem.isEnabled = false
            
            
            VC.viewControllers = [promiseVC, chatVC, dummyVC, friendVC, myPageVC]
            self?.rootViewController.setViewControllers([VC], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: tabBarFlow, withNextStepper: VM),
            .contribute(withNextPresentable: promiseFlow, withNextStepper: OneStepper(withSingleStep: PromiseStep.newPromiseInNoti)),
            .contribute(withNextPresentable: chatFlow, withNextStepper: OneStepper(withSingleStep: ChatStep.chatList)),
            .contribute(withNextPresentable: friendFlow, withNextStepper: OneStepper(withSingleStep: FriendStep.friend)),
            .contribute(withNextPresentable: myPageFlow, withNextStepper: OneStepper(withSingleStep: MyPageStep.myPage))
        ])
    }
    
    private func navigateTotabBarAndFriend() -> FlowContributors {
        let VM = TabBarViewModel(stompService: self.stompService)
        let VC = TabBarController(tabBarViewModel: VM)
        
        let promiseNC = UINavigationController()
        promiseNC.isNavigationBarHidden = true
        let chatNC = UINavigationController()
        chatNC.isNavigationBarHidden = true
        let friendNC = UINavigationController()
        friendNC.isNavigationBarHidden = true
        let myPageNC = UINavigationController()
        myPageNC.isNavigationBarHidden = true
        
        
        self.promiseFlow = PromiseFlow(with: promiseNC, stompService: self.stompService)
        self.chatFlow = ChatFlow(with: chatNC, stompService: self.stompService)
        self.friendFlow = FriendFlow(with: friendNC)
        self.myPageFlow = MyPageFlow(with: myPageNC)
        self.tabBarFlow = TabBarFlow(with: rootViewController, stompService: self.stompService, promiseFlow: self.promiseFlow, friendFlow: self.friendFlow)
        Flows.use(promiseFlow, chatFlow, friendFlow, myPageFlow, when: .created) { [weak self] (promiseVC, chatVC, friendVC, myPageVC) in
            
            promiseVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"),tag: 0)
            chatVC.tabBarItem = UITabBarItem(title: "채팅방", image: UIImage(named: "chat")?.withRenderingMode(.alwaysOriginal),tag: 1)
            friendVC.tabBarItem = UITabBarItem(title: "친구", image: UIImage(named: "friend")?.withRenderingMode(.alwaysOriginal), tag: 3)
            myPageVC.tabBarItem = UITabBarItem(title: "사용자", image: UIImage(named: "userGrey")?.withRenderingMode(.alwaysOriginal), tag: 4)

            let dummyVC = UIViewController()
            dummyVC.tabBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
            dummyVC.tabBarItem.isEnabled = false
            
            
            VC.viewControllers = [promiseVC, chatVC, dummyVC, friendVC, myPageVC]
            self?.rootViewController.setViewControllers([VC], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: tabBarFlow, withNextStepper: VM),
            .contribute(withNextPresentable: promiseFlow, withNextStepper: OneStepper(withSingleStep: PromiseStep.home)),
            .contribute(withNextPresentable: chatFlow, withNextStepper: OneStepper(withSingleStep: ChatStep.chatList)),
            .contribute(withNextPresentable: friendFlow, withNextStepper: OneStepper(withSingleStep: FriendStep.requestFriendInNoti)),
            .contribute(withNextPresentable: myPageFlow, withNextStepper: OneStepper(withSingleStep: MyPageStep.myPage))
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
    
    private func navigateToTerms() -> FlowContributors {
        let VM = TPViewModel(currentFlow: .AppFlow)
        let VC = TermViewController(tPViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigatePolicies() -> FlowContributors {
        let VM = TPViewModel(currentFlow: .AppFlow)
        let VC = PolicyViewController(tPViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func presentNetworkErrorPopup() -> FlowContributors {
        let VC = NetworkErrorPopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
    private func presentInputErrorPopup() -> FlowContributors {
        let VC = InputErrorPopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
    private func terminateAllFlows() -> FlowContributors {
        let VM = LoginViewModel(authService: authService, currentFlow: .AppFlow)
        let VC = LoginViewController(loginViewModel: VM)
        self.rootViewController.setViewControllers([VC], animated: false)
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: VC, withNextStepper: VM),
            .contribute(withNextPresentable: tabBarFlow, withNextStepper: OneStepper(withSingleStep: TabBarStep.endFlow)),
            .contribute(withNextPresentable: promiseFlow, withNextStepper: OneStepper(withSingleStep: PromiseStep.endFlow)),
            //.contribute(withNextPresentable: chatFlow, withNextStepper: OneStepper(withSingleStep: ChatStep.endFlow)),
            .contribute(withNextPresentable: friendFlow, withNextStepper: OneStepper(withSingleStep: FriendStep.endFlow)),
            .contribute(withNextPresentable: myPageFlow, withNextStepper: OneStepper(withSingleStep: MyPageStep.endFlow)),
        ])
    }
    
}

