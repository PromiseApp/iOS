import Foundation
import Moya

enum PromiseAPI {
    case RegisterPromise(title: String, date: String,  friends:[String], place: String?, penalty: String?, memo: String?)
    case PromiseList(startDateTime: String, endDateTime: String, completed: String)
    case NewPromiseList
    case InviteFriend(promiseId: String, members:[String])
    case AcceptPromise(id: String)
    case RejectPromise(id: String)
    case DetailPromise(promiseId: String)
    case DeletePromise(promiseId: String)
    case OutPromise(promiseId: String)
    case ModifyPromise(promiseId: String ,title: String, date: String, place: String?, penalty: String?, memo: String?)
    case ResultPromise(promiseId: String, nickname: String, isSucceed: String)
    case GetUserData
}

extension PromiseAPI: TargetType {

    var baseURL: URL {
        return URL(string: "http://15.164.166.199:8080")!
    }
    
    var path: String {
        switch self {
        case .RegisterPromise:
            return "/promise/create"
        case .PromiseList:
            return "/promise/getPromiseList"
        case .NewPromiseList:
            return "/promise/getPromiseRequestList"
        case .InviteFriend:
            return "/promise/inviteFriend"
        case .AcceptPromise:
            return "/promise/acceptPromiseRequest"
        case .RejectPromise:
            return "/promise/rejectPromiseRequest"
        case .DetailPromise:
            return "/promise/getPromiseInfo"
        case .DeletePromise:
            return "/promise/deletePromise"
        case .OutPromise:
            return "/promise/exitPromise"
        case .ModifyPromise:
            return "/promise/editPromise"
        case .ResultPromise:
            return "/promise/result"
        case .GetUserData:
            return "/member/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .RegisterPromise:
            return .post
        case .PromiseList:
            return .get
        case .NewPromiseList:
            return .get
        case .InviteFriend:
            return .post
        case .AcceptPromise:
            return .post
        case .RejectPromise:
            return .post
        case .DetailPromise:
            return .get
        case .DeletePromise:
            return .post
        case .OutPromise:
            return .post
        case .ModifyPromise:
            return .post
        case .ResultPromise:
            return .post
        case .GetUserData:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .RegisterPromise(let title, let date, let friends, let place, let penalty, let memo):
            var info: [String: Any] = [
                "title": title,
                "date": date
            ]
            if let place = place {
                info["location"] = place
            }
            if let penalty = penalty {
                info["penalty"] = penalty
            }
            if let memo = memo {
                info["memo"] = memo
            }
            let members = friends.map { ["nickname": $0] }
            let parameters: [String: Any] = [
                        "info": info,
                        "members": members
                    ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .PromiseList(let startDateTime, let endDateTime, let completed):
            let parameters: [String: Any] = ["startDateTime": startDateTime,
                                             "endDateTime": endDateTime,
                                             "completed": completed]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .NewPromiseList:
            return .requestPlain
        case .InviteFriend(let promiseId, let members):
            let memberDicts = members.map { ["nickname": $0] }
            let parameters: [String: Any] = [
                "promiseId": promiseId,
                "members": memberDicts
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .AcceptPromise(let id):
            return .requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
        case .RejectPromise(let id):
            return .requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
        case .DetailPromise(let promiseId):
            return .requestParameters(parameters: ["promiseId": promiseId], encoding: URLEncoding.queryString)
        case .DeletePromise(let promiseId):
            return .requestParameters(parameters: ["promiseId": promiseId], encoding: JSONEncoding.default)
        case .OutPromise(let promiseId):
            return .requestParameters(parameters: ["promiseId": promiseId], encoding: JSONEncoding.default)
        case .ModifyPromise(let promiseId, let title, let date, let place, let penalty, let memo):
            var parameters: [String: Any] = [
                "promiseId": promiseId,
                "title": title,
                "date": date
            ]
            if let place = place {
                parameters["location"] = place
            }
            if let penalty = penalty {
                parameters["penalty"] = penalty
            }
            if let memo = memo {
                parameters["memo"] = memo
            }
            
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .ResultPromise(let promiseId, let nickname, let isSucceed):
            let result: [String: String] = ["nickname": nickname, "isSucceed": isSucceed]
                let parameters: [String: Any] = [
                    "promiseId": promiseId,
                    "result": [result]
                ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .GetUserData:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        if let user = DatabaseManager.shared.fetchUser(){
            headers["Authorization"] = "Bearer \(user.accessToken)"
        }
        return headers
    }
    
}
