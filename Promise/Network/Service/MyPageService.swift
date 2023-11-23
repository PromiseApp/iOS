import Moya
import RxMoya
import RxSwift

protocol MyPageServiceProtocol {
    func createInquiry(author: String, title: String, content: String, type: String) -> Single<MyPageResponse>
    func replyInquiry(postId: String, author: String, title: String, content: String) -> Single<MyPageResponse>
    func inquiryList(nickname: String, period: String, statusType: String) -> Single<InquiryListResponse>
    func noticeList() -> Single<NoticeListResponse>
    func GetExp() -> Single<GetUserExp>
}

class MyPageService: MyPageServiceProtocol {
    private let provider = MoyaProvider<MyPageAPI>()
    
    func createInquiry(author: String, title: String, content: String, type: String) -> Single<MyPageResponse> {
        return provider.rx.request(.CreateInquiry(author: author, title: title, content: content, type: type))
            .filterSuccessfulStatusCodes()
            .map(MyPageResponse.self)
    }
    
    func replyInquiry(postId: String, author: String, title: String, content: String) -> Single<MyPageResponse> {
        return provider.rx.request(.ReplyInquiry(postId: postId, author: author, title: title, content: content))
            .filterSuccessfulStatusCodes()
            .map(MyPageResponse.self)
    }
    
    func inquiryList(nickname: String, period: String, statusType: String) -> Single<InquiryListResponse> {
        return provider.rx.request(.InquiryList(nickname: nickname, period: period, statusType: statusType))
            .filterSuccessfulStatusCodes()
            .map(InquiryListResponse.self)
    }
    
    func noticeList() -> Single<NoticeListResponse> {
        return provider.rx.request(.NoticeList)
            .filterSuccessfulStatusCodes()
            .map(NoticeListResponse.self)
    }
    
    func GetExp() -> Single<GetUserExp> {
        return provider.rx.request(.GetExp)
            .filterSuccessfulStatusCodes()
            .map(GetUserExp.self)
    }
    
}

