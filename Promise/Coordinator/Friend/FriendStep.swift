import RxFlow

enum FriendStep: Step {
    case friend
    case addFriendPopup
    case requestFriend
    case rejectFriendPopup(requesterID: String)
    case networkErrorPopup
    case alreadyRequestFriendPopup
    case requestNotExistFriendPopup
    case popView
    case dismissView
}
