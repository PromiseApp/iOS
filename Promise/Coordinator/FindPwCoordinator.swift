import UIKit

class FindPwCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: MainCoordinator?) {
            self.navigationController = navigationController
            self.parentCoordinator = parentCoordinator
        }
    
    func start() {
        let VM = FindPwViewModel()
        let VC = FindPwViewController(findPwViewModel: VM, findPwCoordinator: self)
        navigationController.pushViewController(VC, animated: true)
    }
    
    func goToConfirmEmailAuthVC() {
        let VM = ConfirmEmailAuthViewModel()
        let VC = ConfirmEmailAuthViewController(confirmEmailAuthViewModel: VM, signupCoordinator: nil,findPwCoordinator: self)
        navigationController.pushViewController(VC, animated: true)
    }
    
    func goToChangePwVC(){
        let VM = ChangePwViewModel()
        let VC = ChangePwViewController(changePwViewModel: VM, findPwCoordinator: self)
        navigationController.pushViewController(VC, animated: true)
    }
    
    func popToVC(){
        navigationController.popViewController(animated: true)
    }
    
    
    func finishSignup() {
        parentCoordinator?.childCoordinators.removeAll { $0 is FindPwCoordinator }
        navigationController.popToRootViewController(animated: true)
    }
}
