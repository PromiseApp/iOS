import UIKit
import RxFlow

class MyPageFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    let limitedVM = LimitedViewModel()
    let myPageService = MyPageService()
    
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
        case .detailInquiry(let inquiryId):
            return navigateToDetailInquiry(inquiryId: inquiryId)
        case .logoutCompleted:
            return .end(forwardToParentFlowWithStep: AppStep.logoutCompleted)
        case .withdrawPopup:
            return presentWithdrawPopup()
        case .networkErrorPopup:
            return presentNetworkErrorPopup()
        case .dismissView:
            return dismissViewController()
        case .popView:
            return popViewController()
        }
    }
    
    private func navigateToMyPage() -> FlowContributors {
        let VM = MyPageViewModel(myPageService: myPageService)
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
        let VM = NicknameViewModel(flowType: .myPageFlow,loginService: AuthService())
        let VC = ChangeNicknameViewController(nicknameViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToAnnouncement() -> FlowContributors {
        let VM = AnnouncementViewModel(myPageService: myPageService, role: UserSession.shared.role)
        let VC = AnnouncementViewController(announcementViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToInquiryList() -> FlowContributors {
        let VM = InquiryViewModel(myPageService: myPageService, role: UserSession.shared.role)
        let VC = InquiryViewController(inquiryViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToWriteInquiry() -> FlowContributors {
        let VM = WriteInquiryViewModel(myPageService: myPageService)
        let VC = WriteInquiryViewController(writeInquiryViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToDetailInquiry( inquiryId: String) -> FlowContributors {
        let VM = DetailInquiryViewModel(role: UserSession.shared.role, inquiryId: inquiryId)
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
    
    private func presentNetworkErrorPopup() -> FlowContributors {
        let VC = NetworkErrorPopupViewController()
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

