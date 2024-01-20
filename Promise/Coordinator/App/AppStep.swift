import RxFlow

enum AppStep: Step {
    case loading
    case login
    case tabBar
    case signup
    case findPw
    case signupCompleted
    case findPwCompleted
    case terms
    case policies
    case networkErrorPopup
    case inputErrorPopup
    case popView
    case endAllFlows
    case endAllFlowsCompleted
}

enum TPFlowType {
    case AppFlow
    case myPageFlow
}
