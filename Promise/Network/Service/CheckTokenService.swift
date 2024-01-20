import Moya
import RxMoya
import RxSwift

protocol CheckTokenServiceProtocol {
    func checkToken(refreshToken: String) -> Single<CheckTokenResponse>
}

class CheckTokenService: CheckTokenServiceProtocol {
    private let provider = MoyaProvider<CheckTokenAPI>()
    
    func checkToken(refreshToken: String) -> Single<CheckTokenResponse> {
        return provider.rx.request(.checkToken(refreshToken: refreshToken))
            .filterSuccessfulStatusCodes()
            .map(CheckTokenResponse.self)
    }
}

