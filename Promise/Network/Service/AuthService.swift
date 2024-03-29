import Moya
import UIKit
import RxMoya
import RxSwift

protocol AuthServiceProtocol {
    func signUp(account: String, password: String, nickname:String, img: UIImage?) -> Single<AuthResponse>
    func login(account: String, password: String) -> Single<LoginResponse>
    func duplicateCheckAccount(account: String) -> Single<DuplicateCheckResponse>
    func duplicateCheckNickname(nickname: String) -> Single<DuplicateCheckResponse>
    func postEmail(account: String) -> Single<PostEmailResponse>
    func changePasswordInLogin(account: String, password: String) -> Single<AuthResponse>
    func changePassword(password: String) -> Single<AuthResponse>
    func changeNickname(nickname: String) -> Single<AuthResponse>
    func changeImage(img: UIImage?) -> Single<UpdateUserProfileResponse>
    func withdraw() -> Single<WithdrawResponse>
}

class AuthService: AuthServiceProtocol {
    private let provider = MoyaProvider<AuthAPI>()
    
    func signUp(account: String, password: String, nickname:String, img: UIImage?) -> Single<AuthResponse> {
        return provider.rx.request(.signup(account: account, password: password, nickname: nickname, img: img))
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
    
    func postEmail(account: String) -> Single<PostEmailResponse> {
        return provider.rx.request(.postEmail(account: account))
            .filterSuccessfulStatusCodes()
            .map(PostEmailResponse.self)
    }
    
    func changePasswordInLogin(account: String, password: String) -> Single<AuthResponse> {
        return provider.rx.request(.changePasswordInLogin(account: account, password: password))
            .filterSuccessfulStatusCodes()
            .map(AuthResponse.self)
    }
    
    func changePassword(password: String) -> Single<AuthResponse> {
        return provider.rx.request(.changePassword(password: password))
            .filterSuccessfulStatusCodes()
            .map(AuthResponse.self)
    }
    
    func changeNickname(nickname: String) -> Single<AuthResponse> {
        return provider.rx.request(.changeNickname(nickname: nickname))
            .filterSuccessfulStatusCodes()
            .map(AuthResponse.self)
    }
    
    func changeImage(img: UIImage?) -> Single<UpdateUserProfileResponse> {
        return provider.rx.request(.changeImage(img: img))
            .filterSuccessfulStatusCodes()
            .map(UpdateUserProfileResponse.self)
    }
    
    func withdraw() -> Single<WithdrawResponse> {
        return provider.rx.request(.withdraw)
            .filterSuccessfulStatusCodes()
            .map(WithdrawResponse.self)
    }
    
}

