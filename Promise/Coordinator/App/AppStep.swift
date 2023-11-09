import RxFlow

enum AppStep: Step {
    case login
    case tabBar
    case signup
    case findPw
    case signupCompleted
    case findPwCompleted
    case networkErrorPopup
}
