import UIKit

class FindPwCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: StartCoordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: StartCoordinator?) {
            self.navigationController = navigationController
            self.parentCoordinator = parentCoordinator
        }
    
    func start() {
        let VM = FindPwViewModel()
        let VC = FindPwViewController(findPwViewModel: VM, findPwCoordinator: self)
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
