import RxFlow

enum SignupStep: Step {
    case emailAuth
    case confirmEmailAuth
    case nickname
    case signup
    case limitedCollectionView
    case signupCompleted
    case popView
    case dismissView
    case inputErrorPopup
}
