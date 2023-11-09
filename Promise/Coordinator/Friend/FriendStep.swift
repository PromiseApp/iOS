import RxFlow

enum FriendStep: Step {
    case friend
    case addFriendPopup
    case requestFriend
    case rejectFriendPopup
    case networkErrorPopup
    case popView
    case dismissView
}
