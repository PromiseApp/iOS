import RxFlow

enum MyPageStep: Step {
    case myPage
    case changeProfile
    case limitedCollectionView
    case changePw
    case changeNickname
    case announcement
    case withdrawPopup
    case dismissView
    case popView
}

enum FlowType {
    case singupFlow
    case findPwFlow
    case myPageFlow
}
