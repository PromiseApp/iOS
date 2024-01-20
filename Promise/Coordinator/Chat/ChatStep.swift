import RxFlow

enum ChatStep: Step {
    case chatList
    case chatRoom(promiseId: Int)
    case tokenExpirationPopup
    case networkErrorPopup
    case popView
    case endFlow
}
