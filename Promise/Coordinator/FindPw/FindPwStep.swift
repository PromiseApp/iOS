import RxFlow

enum FindPwStep: Step {
    case inputEmail
    case confirmEmailAuth
    case changePw
    case findPwCompleted
    case duplicateAccountErrorPopup
    case inputErrorPopup
    case networkErrorPopup
    case dismissView
    case popView
}
