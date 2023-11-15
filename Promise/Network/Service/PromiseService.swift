import Moya
import RxMoya
import RxSwift

protocol PromiseServiceProtocol {
    func registerPromise(title: String, date: String,  friends:[String], place: String?, penalty: String?, memo: String?) -> Single<RegisterPromiseResponse>
    func promiseList(startDateTime: String, endDateTime: String, completed: String) -> Single<PromiseListResponse>
    func newPormiseList() -> Single<NewPromiseListResponse>
    func acceptPromise(id: String) -> Single<PromiseResponse>
    func rejectPromise(id: String) -> Single<PromiseResponse>
    func detailPromise(promiseId: String) -> Single<PromiseDetailResponse>
    func resultPromise(promiseId: String, nickname: String, isSucceed: String) -> Single<PromiseResponse>
}

class PromiseService: PromiseServiceProtocol {
    private let provider = MoyaProvider<PromiseAPI>()
    func registerPromise(title: String, date: String, friends: [String], place: String?, penalty: String?, memo: String?) -> Single<RegisterPromiseResponse> {
        return provider.rx.request(.RegisterPromise(title: title, date: date, friends: friends, place: place, penalty: penalty, memo: memo))
            .filterSuccessfulStatusCodes()
            .map(RegisterPromiseResponse.self)
    }
    
    func promiseList(startDateTime: String, endDateTime: String, completed: String) -> Single<PromiseListResponse> {
        return provider.rx.request(.PromiseList(startDateTime: startDateTime, endDateTime: endDateTime, completed: completed))
            .filterSuccessfulStatusCodes()
            .map(PromiseListResponse.self)
    }
    
    func newPormiseList() -> Single<NewPromiseListResponse> {
        return provider.rx.request(.NewPromiseList)
            .filterSuccessfulStatusCodes()
            .map(NewPromiseListResponse.self)
    }
    
    func acceptPromise(id: String) -> Single<PromiseResponse> {
        return provider.rx.request(.AcceptPromise(id: id))
            .filterSuccessfulStatusCodes()
            .map(PromiseResponse.self)
    }
    
    func rejectPromise(id: String) -> Single<PromiseResponse> {
        return provider.rx.request(.RejectPromise(id: id))
            .filterSuccessfulStatusCodes()
            .map(PromiseResponse.self)
    }
    
    func detailPromise(promiseId: String) -> Single<PromiseDetailResponse> {
        return provider.rx.request(.DetailPromise(promiseId: promiseId))
            .filterSuccessfulStatusCodes()
            .map(PromiseDetailResponse.self)
    }
    
    func resultPromise(promiseId: String, nickname: String, isSucceed: String) -> Single<PromiseResponse> {
        return provider.rx.request(.ResultPromise(promiseId: promiseId, nickname: nickname, isSucceed: isSucceed))
            .filterSuccessfulStatusCodes()
            .map(PromiseResponse.self)
    }
    
}

