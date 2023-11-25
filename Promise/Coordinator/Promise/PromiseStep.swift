import RxFlow

enum PromiseStep: Step {
    case home
    case newPromise
    case makePromise
    case selectFriend
    case pastPromise
    case selectPromiseResult
    case selectMemberResult
    case modifyPromise(promiseId: String, type: String)
    case selectFriendForModify
    case networkErrorPopup
    case deletedPromisePopup
    case outPromisePopup(promiseId: String)
    case popView
    case dismissView
}

enum PromiseFlowType {
    case tabBarFlow
    case promiseFlow
}
