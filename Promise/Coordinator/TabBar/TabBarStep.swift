import RxFlow

enum TabBarStep: Step {

    case makePromise
    case selectFriend
    case tokenExpirationPopup
    case networkErrorPopup
    case popRootView
    case popView
    case endFlow
}
