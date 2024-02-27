import RxFlow

enum ChatStep: Step {
    case chatList
    case chatRoom(promiseId: Int, promiseTitle: String?)
    case tokenExpirationPopup
    case networkErrorPopup
    case popView
    case endFlow
}
