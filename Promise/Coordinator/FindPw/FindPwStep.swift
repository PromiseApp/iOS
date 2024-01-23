import RxFlow

enum FindPwStep: Step {
    case inputEmail
    case confirmEmailAuth
    case changePw
    case findPwCompleted
    case noneAccountErrorPopup
    case networkErrorPopup
    case dismissView
    case popView
}
