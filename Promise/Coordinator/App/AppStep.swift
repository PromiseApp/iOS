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
    case terms
    case policies
    case networkErrorPopup
    case inputErrorPopup
    case popView
}

enum TPFlowType {
    case AppFlow
    case myPageFlow
}
