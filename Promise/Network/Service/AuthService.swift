import Moya
import RxMoya
import RxSwift

protocol AuthServiceProtocol {
    func signUp(account: String, password: String, nickname:String, image: String?) -> Single<AuthResponse>
    func login(account: String, password: String) -> Single<LoginResponse>
    func duplicateCheckAccount(account: String) -> Single<DuplicateCheckResponse>
    func duplicateCheckNickname(nickname: String) -> Single<DuplicateCheckResponse>
    func changePassword(password: String) -> Single<AuthResponse>
    func changeNickname(nickname: String) -> Single<AuthResponse>
    func changeImage(img: String) -> Single<AuthResponse>
    func withdraw() -> Single<WithdrawResponse>
}

class AuthService: AuthServiceProtocol {
    private let provider = MoyaProvider<AuthAPI>()
    
    func signUp(account: String, password: String, nickname:String, image: String?) -> Single<AuthResponse> {
        return provider.rx.request(.signup(account: account, password: password, nickname: nickname, image: image))
            .filterSuccessfulStatusCodes()
            .map(AuthResponse.self)
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
    
    func changePassword(password: String) -> Single<AuthResponse> {
        return provider.rx.request(.ChangePassword(password: password))
            .filterSuccessfulStatusCodes()
            .map(AuthResponse.self)
    }
    
    func changeNickname(nickname: String) -> Single<AuthResponse> {
        return provider.rx.request(.ChangeNickname(nickname: nickname))
            .filterSuccessfulStatusCodes()
            .map(AuthResponse.self)
    }
    
    func changeImage(img: String) -> Single<AuthResponse> {
        return provider.rx.request(.ChangeImage(img: img))
            .filterSuccessfulStatusCodes()
            .map(AuthResponse.self)
    }
    
    func withdraw() -> Single<WithdrawResponse> {
        return provider.rx.request(.Withdraw)
            .filterSuccessfulStatusCodes()
            .map(WithdrawResponse.self)
    }
    
}

