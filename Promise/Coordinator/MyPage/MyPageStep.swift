import RxFlow

enum MyPageStep: Step {
    case myPage
    case changeProfile
    case limitedCollectionView
    case changePw
    case changeNickname
    case announcement
    case inquiryList
    case writeInquiry(type: String)
    case detailInquiry(inquiryId: String)
    case termsAndPolicies
    case terms
    case policies
    case logoutCompleted
    case withdrawPopup
    case networkErrorPopup
    case dismissView
    case popView
}

enum FlowType {
    case singupFlow
    case findPwFlow
    case myPageFlow
}
