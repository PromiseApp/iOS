import Moya
import RxMoya
import RxSwift

protocol PromiseServiceProtocol {
    func registerPromise(title: String, date: String,  friends:[String], place: String?, penalty: String?, memo: String?) -> Single<RegisterPromiseResponse>
    func promiseList(startDateTime: String, endDateTime: String, completed: String) -> Single<PromiseListResponse>
    func newPormiseList() -> Single<NewPromiseListResponse>
    func inviteFriend(promiseId: String, members: [String]) -> Single<PromiseResponse>
    func acceptPromise(id: String) -> Single<PromiseResponse>
    func rejectPromise(id: String) -> Single<PromiseResponse>
    func detailPromise(promiseId: String) -> Single<PromiseDetailResponse>
    func deletePromise(promiseId: String) -> Single<PromiseResponse>
    func outPromise(promiseId: String) -> Single<PromiseResponse>
    func modifyPromise(promiseId:String, title: String, date: String, place: String?, penalty: String?, memo: String?) -> Single<PromiseResponse>
    func resultPromise(promiseId: String, nickname: String, isSucceed: String) -> Single<PromiseResponse>
    func GetUserData() -> Single<GetUserData>
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
    
    func inviteFriend(promiseId: String, members: [String]) -> Single<PromiseResponse> {
        provider.rx.request(.InviteFriend(promiseId: promiseId, members: members))
            .filterSuccessfulStatusCodes()
            .map(PromiseResponse.self)
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
    
    func deletePromise(promiseId: String) -> Single<PromiseResponse> {
        return provider.rx.request(.DeletePromise(promiseId: promiseId))
            .filterSuccessfulStatusCodes()
            .map(PromiseResponse.self)
    }
    
    func outPromise(promiseId: String) -> Single<PromiseResponse> {
        return provider.rx.request(.OutPromise(promiseId: promiseId))
            .filterSuccessfulStatusCodes()
            .map(PromiseResponse.self)
    }
    
    func modifyPromise(promiseId:String, title: String, date: String, place: String?, penalty: String?, memo: String?) -> Single<PromiseResponse> {
        return provider.rx.request(.ModifyPromise(promiseId: promiseId, title: title, date: date, place: place, penalty: penalty, memo: memo))
            .filterSuccessfulStatusCodes()
            .map(PromiseResponse.self)
    }
    
    func resultPromise(promiseId: String, nickname: String, isSucceed: String) -> Single<PromiseResponse> {
        return provider.rx.request(.ResultPromise(promiseId: promiseId, nickname: nickname, isSucceed: isSucceed))
            .filterSuccessfulStatusCodes()
            .map(PromiseResponse.self)
    }
    
    func GetUserData() -> Single<GetUserData> {
        return provider.rx.request(.GetUserData)
            .filterSuccessfulStatusCodes()
            .map(GetUserData.self)
    }
    
}

