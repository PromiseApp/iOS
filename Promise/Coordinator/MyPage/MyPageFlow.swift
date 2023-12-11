import UIKit
import RxFlow

class MyPageFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    let limitedVM = LimitedViewModel(currentFlow: .myPageFlow)
    let myPageService = MyPageService()
    let authService = AuthService()
    
    let user = DatabaseManager.shared.fetchUser()
    
    init(with rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
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
        case .writeInquiry(let type):
            return navigateToWriteInquiry(type: type)
        case .detailInquiry(let inquiryId):
            return navigateToDetailInquiry(inquiryId: inquiryId)
        case .termsAndPolicies:
            return navigateToTermsAndPolicies()
        case .terms:
            return navigateToTerms()
        case .policies:
            return navigatePolicies()
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
        let VM = ChangeProfileViewModel(authService: authService)
        let VC = ChangeProfileViewController(changeProfileViewModel: VM, limitedViewModel: limitedVM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToLimitedCollectionView() -> FlowContributors {
        let VC = LimitedViewController(limitedViewModel: limitedVM)
        rootViewController.present(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: limitedVM))
    }
    
    private func navigateToChangePw() -> FlowContributors {
        let VM = ChangePwViewModel(authService: authService, flowType: .myPageFlow)
        let VC = ChangePwViewController(changePwViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToChangeNickname() -> FlowContributors {
        let VM = NicknameViewModel(flowType: .myPageFlow, authService: authService)
        let VC = ChangeNicknameViewController(nicknameViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToAnnouncement() -> FlowContributors {
        let VM = AnnouncementViewModel(myPageService: myPageService, role: user!.role)
        let VC = AnnouncementViewController(announcementViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToInquiryList() -> FlowContributors {
        let VM = InquiryViewModel(myPageService: myPageService, role: user!.role)
        let VC = InquiryViewController(inquiryViewModel: VM)
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToWriteInquiry(type: String) -> FlowContributors {
        let VM = WriteInquiryViewModel(myPageService: myPageService, type: type)
        let VC = WriteInquiryViewController(writeInquiryViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToDetailInquiry( inquiryId: String) -> FlowContributors {
        let VM = DetailInquiryViewModel(myPageService: myPageService, role: user!.role, inquiryId: inquiryId)
        let VC = DetailInquiryViewController(detailInquiryViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToTermsAndPolicies() -> FlowContributors {
        let VM = TPViewModel(currentFlow: .myPageFlow)
        let VC = TPViewController(tPViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        VC.hidesBottomBarWhenPushed = true
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToTerms() -> FlowContributors {
        let VM = TPViewModel(currentFlow: .myPageFlow)
        let VC = TermViewController(tPViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigatePolicies() -> FlowContributors {
        let VM = TPViewModel(currentFlow: .myPageFlow)
        let VC = PolicyViewController(tPViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func presentWithdrawPopup() -> FlowContributors {
        let VM = WithdrawPopupViewModel(authService: authService)
        let VC = WithdrawPopupViewController(withdrawPopupViewModel: VM)
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func presentNetworkErrorPopup() -> FlowContributors {
        let VC = NetworkErrorPopupViewController()
        VC.modalPresentationStyle = .overFullScreen
        rootViewController.present(VC, animated: false)
        return .none
    }
    
    private func popViewController() -> FlowContributors {
        rootViewController.popViewController(animated: true)
        return .none
    }
    
    private func dismissViewController() -> FlowContributors {
        rootViewController.dismiss(animated: false)
        return .none
    }
    
}

