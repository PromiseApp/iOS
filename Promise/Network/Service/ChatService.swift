import Moya
import RxMoya
import RxSwift

protocol ChatServiceProtocol {
    func chatList() -> Single<ChatListResponse>
}

class ChatService: ChatServiceProtocol {
    private let provider = MoyaProvider<ChatAPI>()
    
    func chatList() -> Single<ChatListResponse> {
        return provider.rx.request(.chatList)
            .filterSuccessfulStatusCodes()
            .map(ChatListResponse.self)
    }
    
}

