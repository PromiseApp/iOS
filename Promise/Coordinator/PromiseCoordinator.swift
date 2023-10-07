import UIKit

class PromiseCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: MainCoordinator?
    var shareFriendViewModel = ShareFriendViewModel()
    
    init(navigationController: UINavigationController, parentCoordinator: MainCoordinator?) {
            self.navigationController = navigationController
            self.parentCoordinator = parentCoordinator
        }
    
    func start() {
        let VM = PromiseViewModel()
        let VC = PromiseViewController(promiseViewModel: VM, promiseCoordinator: self)
        navigationController.pushViewController(VC, animated: true)
    }
    
    func goToMakePromiseVC(){
        let VM = MakePromiseViewModel(shareFriendViewModel: self.shareFriendViewModel)
        let VC = MakePromiseViewController(makePromiseViewModel: VM, promiseCoordinator: self)
        navigationController.pushViewController(VC, animated: true)
    }
    
    func goToSelectFriendVC(){
        let VM = SelectFriendViewModel(shareFriendViewModel: self.shareFriendViewModel)
        let VC = SelectFriendViewController(selectFriendViewModel: VM, promiseCoordinator: self)
        navigationController.pushViewController(VC, animated: true)
    }
    
    func popToVC(){
        navigationController.popViewController(animated: true)
    }
   
}
