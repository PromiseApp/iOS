import Moya
import RxMoya
import RxSwift

protocol FriendServiceProtocol {
    func friendList() -> Single<FriendListResponse>
    func requestFriendList() -> Single<RequestFriendListResponse>
    func requestFriend(respondent: String) -> Single<RequestFriendResponse>
    func requestFriendAccept(requestId: String) -> Single<RequestFriendResponse>
    func requestFriendReject(requestId: String) -> Single<RequestFriendResponse>
}

class FriendService: FriendServiceProtocol {
    private let provider = MoyaProvider<FriendAPI>()
    
    func friendList() -> Single<FriendListResponse> {
        return provider.rx.request(.FriendList)
            .filterSuccessfulStatusCodes()
            .map(FriendListResponse.self)
    }
    
    func requestFriendList() -> Single<RequestFriendListResponse> {
        return provider.rx.request(.RequestedFriendList)
            .filterSuccessfulStatusCodes()
            .map(RequestFriendListResponse.self)
    }
    
    func requestFriend(respondent: String) -> Single<RequestFriendResponse> {
        return provider.rx.request(.RequestFriend(respondent: respondent))
            .filterSuccessfulStatusCodes()
            .map(RequestFriendResponse.self)
    }
    
    func requestFriendAccept(requestId: String) -> Single<RequestFriendResponse> {
        return provider.rx.request(.RequestFriendAccept(requestId: requestId))
            .filterSuccessfulStatusCodes()
            .map(RequestFriendResponse.self)
    }
    
    func requestFriendReject(requestId: String) -> Single<RequestFriendResponse> {
        return provider.rx.request(.RequestFriendReject(requestId: requestId))
            .filterSuccessfulStatusCodes()
            .map(RequestFriendResponse.self)
    }
    
}

