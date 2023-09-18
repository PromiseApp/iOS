import UIKit

class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: StartCoordinator?
    
    init(navigationController: UINavigationController, parentCoordinator: StartCoordinator?) {
            self.navigationController = navigationController
            self.parentCoordinator = parentCoordinator
        }
    
    func start() {
        
    }
   
}
