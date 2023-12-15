import RxFlow

enum ChatStep: Step {
    case chatList
    case chatRoom(promiseId: Int)
    case networkErrorPopup
    case popView
}
