import UIKit

class FriendCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: MainCoordinator?
    
    
    init(navigationController: UINavigationController, parentCoordinator: MainCoordinator?) {
            self.navigationController = navigationController
            self.parentCoordinator = parentCoordinator
        }
    
    func start() {
        let VM = FriendViewModel()
        let VC = FriendViewController(friendViewModel: VM, friendCoordinator: self)
        navigationController.pushViewController(VC, animated: true)
    }
   
}
