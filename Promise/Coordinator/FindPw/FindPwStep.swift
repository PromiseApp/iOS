import RxFlow

enum FindPwStep: Step {
    case inputEmail
    case confirmEmailAuth
    case changePw
    case findPwCompleted
    case inputErrorPopup
    case dismissView
    case popView
}
