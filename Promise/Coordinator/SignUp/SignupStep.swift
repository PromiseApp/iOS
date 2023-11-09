import RxFlow

enum SignupStep: Step {
    case emailAuth
    case confirmEmailAuth
    case nickname
    case signup
    case limitedCollectionView
    case signupCompleted
    case duplicateAccountErrorPopup
    case inputErrorPopup
    case networkErrorPopup
    case dismissView
    case popView
}
