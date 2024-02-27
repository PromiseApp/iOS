import UIKit
import RxFlow

class ChatFlow: Flow {
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: UINavigationController
    let stompService: StompService
    let chatService = ChatService()
    
    init(with rootViewController: UINavigationController, stompService: StompService) {
        self.rootViewController = rootViewController
        self.stompService = stompService
        self.rootViewController.interactivePopGestureRecognizer?.delegate = nil
        self.rootViewController.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? ChatStep else { return .none }
        
        switch step {
        case .chatList:
            return navigateToChatList()
        case .chatRoom(let promiseId, let title):
            return navigateToChatRoom(promiseId: promiseId, title: title)
        case .tokenExpirationPopup:
            return navigateToTokenExpirationPopup()
        case .networkErrorPopup:
            return presentNetworkErrorPopup()
        case .popView:
            return popViewController()
        case .endFlow:
            return .end(forwardToParentFlowWithStep: AppStep.endAllFlowsCompleted)
        }
    }
    
    private func navigateToChatList() -> FlowContributors {
        let VM = ChatListViewModel(chatService: chatService, stompService: stompService)
        let VC = ChatListViewController(chatListViewModel: VM)
        rootViewController.pushViewController(VC, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToChatRoom(promiseId: Int, title: String?) -> FlowContributors {
        let VM = ChatRoomViewModel(stompService: stompService, promiseID: promiseId, promiseTitle: title)
        let VC = ChatRoomViewController(chatRoomViewModel: VM, participantView: ParticipantView(participantViewModel: ParticipantViewModel(promiseID: promiseId)))
        VC.hidesBottomBarWhenPushed = true
        rootViewController.pushViewController(VC, animated: true)
        
        return .one(flowContributor: .contribute(withNextPresentable: VC, withNextStepper: VM))
    }
    
    private func navigateToTokenExpirationPopup() -> FlowContributors {
        let tokenExpirationFlow = TokenExpirationFlow(with: rootViewController)
        return .one(flowContributor: .contribute(withNextPresentable: tokenExpirationFlow, withNextStepper: OneStepper(withSingleStep: TokenExpirationStep.tokenExpirationPopup)))
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
    
}
