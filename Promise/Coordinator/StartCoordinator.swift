import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class StartCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators = [Coordinator]()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let VM = LoginViewModel()
        let VC = LoginViewController(loginViewModel: VM, startCoordinator: self)
        navigationController.pushViewController(VC, animated: false)
    }
    
//    func start() {
//        // 자동 로그인
//        if UserDefaults.standard.bool(forKey: "IsLoggedIn") {
//            goToMain()
//        } else {
//            let viewModel = StartViewModel()
//            let vc = StartViewController(viewModel: viewModel, coordinator: self)
//            navigationController.pushViewController(vc, animated: false)
//        }
//    }
    
    func goToMain() {
        let VM = TabBarViewModel()
        let tabBarController = TabBarController(tabBarViewModel: VM)
        let mainCoordinator = MainCoordinator(navigationController: UINavigationController(), parentCoordinator: self)
        
        
        childCoordinators = [mainCoordinator]
        
        mainCoordinator.start()
        
        tabBarController.viewControllers = [
            mainCoordinator.navigationController
        ]
        
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    
    func goToEmailAuthVC() {
        let coordinator = SignupCoordinator(navigationController: navigationController, parentCoordinator: self)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
    
    func goToFindPwVC() {
        let coordinator = FindPwCoordinator(navigationController: navigationController, parentCoordinator: self)
        coordinator.start()
        childCoordinators.append(coordinator)
    }
}
