import RxFlow

enum PromiseStep: Step {
    case home
    case makePromise
    case selectFriend
    case pastPromise
    case selectPromiseResult
    case selectMemberResult
    //case modifyPromise(id: String, isManager: Bool)
    case popView
}
