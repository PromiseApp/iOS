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
        case .announcement:
            return navigateToAnnouncement()
        case .inquiryList:
            return navigateToInquiryList()
        case .writeInquiry:
            return navigateToWriteInquiry()
        case .detailInquiry:
            return navigateToDetailInquiry()
        case .withdrawPopup:
            return presentWithdrawPopup()
        case .dismissView:
            return dismissViewController()
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
        let VM = NicknameViewModel(flowType: .myPageFlow,loginService: LoginService())
        let VC = ChangeNicknameViewController(nicknameViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToAnnouncement() -> FlowContributors {
        let VM = AnnouncementViewModel()
        let VC = AnnouncementViewController(announcementViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToInquiryList() -> FlowContributors {
        let VM = InquiryViewModel()
        let VC = InquiryViewController(inquiryViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToWriteInquiry() -> FlowContributors {
        let VM = WriteInquiryViewModel()
        let VC = WriteInquiryViewController(writeInquiryViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToDetailInquiry() -> FlowContributors {
        let VM = DetailInquiryViewModel()
        let VC = DetailInquiryViewController(detailInquiryViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func presentWithdrawPopup() -> FlowContributors {
        let VC = WithdrawPopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
    private func dismissViewController() -> FlowContributors {
        rootViewController.dismiss(animated: true)
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
}

