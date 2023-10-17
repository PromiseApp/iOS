//import UIKit
//
//protocol Coordinator {
//    var navigationController: UINavigationController { get set }
//    func start()
//}
//
//
//class MainCoordinator: Coordinator {
//    var navigationController: UINavigationController
//    var childCoordinators = [Coordinator]()
//
//    init(navigationController: UINavigationController) {
//        self.navigationController = navigationController
//        navigationController.navigationBar.isHidden = true
//    }
//
//    func start() {
//        let VM = LoginViewModel()
//        let VC = LoginViewController(loginViewModel: VM, mainCoordinator: self)
//        navigationController.pushViewController(VC, animated: false)
//    }
//
//    func goToTabBar() {
//        let VM = TabBarViewModel()
//        let tabBarController = TabBarController(tabBarViewModel: VM)
//
//        let promiseCoordinator = PromiseCoordinator(navigationController: UINavigationController(), parentCoordinator: self)
//        let friendCoordinator = FriendCoordinator(navigationController: UINavigationController(), parentCoordinator: self)
//
//        childCoordinators = [promiseCoordinator,friendCoordinator]
//
//        promiseCoordinator.start()
//        friendCoordinator.start()
//
//        let dummyVC = UIViewController()
//        dummyVC.tabBarItem.isEnabled = false
//
//        promiseCoordinator.navigationController.viewControllers.first?.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home"), tag: 0)
//
//        friendCoordinator.navigationController.viewControllers.first?.tabBarItem = UITabBarItem(title: "친구", image: UIImage(named: "friend"), tag: 2)
//
//        tabBarController.viewControllers = [
//            promiseCoordinator.navigationController,
//            dummyVC,
//            friendCoordinator.navigationController
//        ]
//
//        //navigationController.pushViewController(tabBarController, animated: true)
//        navigationController.setViewControllers([tabBarController], animated: false)
//
//    }
//
//
//    func goToEmailAuthVC() {
//        let coordinator = SignupCoordinator(navigationController: navigationController, parentCoordinator: self)
//        coordinator.start()
//        childCoordinators.append(coordinator)
//    }
//
//    func goToFindPwVC() {
//        let coordinator = FindPwCoordinator(navigationController: navigationController, parentCoordinator: self)
//        coordinator.start()
//        childCoordinators.append(coordinator)
//    }
//}
