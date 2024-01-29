import RxFlow

enum PromiseStep: Step {
    case home
    case newPromise
    case newPromiseInNoti
    case makePromise
    case selectFriend
    case pastPromise
    case selectPromiseResult
    case selectMemberResult
    case modifyPromise(promiseId: String, type: String)
    case selectFriendForModify
    case tokenExpirationPopup
    case networkErrorPopup
    case errorDeletedPromisePopup
    case deletePromisePopup(promiseId: String)
    case outPromisePopup(promiseId: String)
    case popView
    case dismissView
    case endFlow
}

enum PromiseFlowType {
    case tabBarFlow
    case promiseFlow
}
