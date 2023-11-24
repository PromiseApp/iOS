import RxFlow

enum AppStep: Step {
    case loading
    case login
    case tabBar
    case signup
    case findPw
    case signupCompleted
    case findPwCompleted
    case logoutCompleted
    case networkErrorPopup
    case inputErrorPopup
}
