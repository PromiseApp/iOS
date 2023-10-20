import UIKit
import RxFlow

class MyPageFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    let limitedVM = LimitedViewModel()
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? MyPageStep else { return .none }
        
        switch step {
        case .myPage:
            return navigateToMyPage()
        case .changeProfile:
            return navigateToChangeProfile()
        case .limitedCollectionView:
            return navigateToLimitedCollectionView()
        case .changePw:
            return navigateToChangePw()
        case .changeNickname:
            return navigateToChangeNickname()
        case .popView:
            return popViewController()
        }
    }
    
    private func navigateToMyPage() -> FlowContributors {
        let VM = MyPageViewModel()
        let VC = MyPageViewController(myPageViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToChangeProfile() -> FlowContributors {
        let VM = ChangeProfileViewModel()
        let VC = ChangeProfileViewController(changeProfileViewModel: VM, limitedViewModel: limitedVM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToLimitedCollectionView() -> FlowContributors {
        let VC = LimitedViewController(limitedViewModel: limitedVM)
        rootViewController.present(VC, animated: true)
        return .none
    }
    
    private func navigateToChangePw() -> FlowContributors {
        let VM = ChangePwViewModel(flowType: .myPageFlow)
        let VC = ChangePwViewController(changePwViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToChangeNickname() -> FlowContributors {
        let VM = NicknameViewModel(flowType: .myPageFlow)
        let VC = ChangeNicknameViewController(nicknameViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
}

