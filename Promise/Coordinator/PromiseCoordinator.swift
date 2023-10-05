import UIKit

class PromiseCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: MainCoordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: MainCoordinator?) {
            self.navigationController = navigationController
            self.parentCoordinator = parentCoordinator
        }
    
    func start() {
        
    }
   
}
