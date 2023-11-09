import Moya
import RxMoya
import RxSwift

protocol LoginServiceProtocol {
    func signUp(account: String, password: String, nickname:String, image: String?) -> Single<SingupResponse>
    func login(account: String, password: String) -> Single<LoginResponse>
    func duplicateCheckAccount(account: String) -> Single<DuplicateCheckResponse>
    func duplicateCheckNickname(nickname: String) -> Single<DuplicateCheckResponse>
}

class LoginService: LoginServiceProtocol {
    private let provider = MoyaProvider<LoginAPI>()
    
    func signUp(account: String, password: String, nickname:String, image: String?) -> Single<SingupResponse> {
        return provider.rx.request(.signup(account: account, password: password, nickname: nickname, image: image))
            .filterSuccessfulStatusCodes()
            .map(SingupResponse.self)
    }
    
    func login(account: String, password: String) -> Single<LoginResponse> {
        return provider.rx.request(.login(account: account, password: password))
            .filterSuccessfulStatusCodes()
            .map(LoginResponse.self)
    }
    
    func duplicateCheckAccount(account: String) -> Single<DuplicateCheckResponse> {
        return provider.rx.request(.duplicateCheckAccount(account: account))
            .filterSuccessfulStatusCodes()
            .map(DuplicateCheckResponse.self)
    }
    
    func duplicateCheckNickname(nickname: String) -> Single<DuplicateCheckResponse> {
        return provider.rx.request(.duplicateCheckNickname(nickname: nickname))
            .filterSuccessfulStatusCodes()
            .map(DuplicateCheckResponse.self)
    }
    
}

