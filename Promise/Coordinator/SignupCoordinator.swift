import UIKit

class SignupCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var parentCoordinator: MainCoordinator?
    var limitedViewModel: LimitedViewModel?
    
    init(navigationController: UINavigationController, parentCoordinator: MainCoordinator?) {
            self.navigationController = navigationController
            self.parentCoordinator = parentCoordinator
        }
    
    func start() {
        let VM = EmailAuthViewModel()
        let VC = EmailAuthViewController(emailAuthViewModel: VM, signupCoordinator: self)
        navigationController.pushViewController(VC, animated: true)
    }
    
    func goToConfirmEmailAuthVC() {
        let VM = ConfirmEmailAuthViewModel()
        let VC = ConfirmEmailAuthViewController(confirmEmailAuthViewModel: VM, signupCoordinator: self,findPwCoordinator: nil)
        navigationController.pushViewController(VC, animated: true)
    }
    
    func goToNicknameVC() {
        let VM = NicknameViewModel()
        let VC = NicknameViewController(nicknameViewModel: VM, signupCoordinator: self)
        navigationController.pushViewController(VC, animated: true)
    }

    func goToSignUpVC() {
        let VM = SignUpViewModel()
        let limitedVM = LimitedViewModel()
        self.limitedViewModel = limitedVM
        let VC = SignUpViewController(signUpViewModel: VM, limitedViewModel: limitedVM, signupCoordinator: self)
        navigationController.pushViewController(VC, animated: true)
    }
    
    func goToLimitedCollectionView() {
        guard let limitedVM = self.limitedViewModel else { return }
        let VC = LimitedViewController(limitedViewModel: limitedVM, signupCoordinator: self)
        navigationController.present(VC, animated: true)
    }
    
    func popToVC(){
        navigationController.popViewController(animated: true)
    }
    
    func dismissToVC(){
        navigationController.dismiss(animated: true)
    }
    
    func finishSignup() {
        parentCoordinator?.childCoordinators.removeAll { $0 is SignupCoordinator }
        navigationController.popToRootViewController(animated: true)
    }
}
