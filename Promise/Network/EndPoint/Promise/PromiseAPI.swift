//
//  PromiseAPI.swift
//  Promise
//
//  Created by 박중선 on 2023/11/11.
//

import Foundation
import Moya

enum PromiseAPI {
    case RegisterPromise(title: String, date: String,  friends:[String], place: String?, penalty: String?, memo: String?)
    case PromiseList(startDateTime: String, endDateTime: String, completed: String)
    case NewPromiseList
    case AcceptPromise(id: String)
    case RejectPromise(id: String)
}

extension PromiseAPI: TargetType {

    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .RegisterPromise:
            return "/promise/create"
        case .PromiseList:
            return "/promise/getPromiseList"
        case .NewPromiseList:
            return "/promise/getPromiseRequestList"
        case .AcceptPromise:
            return "/promise/acceptPromiseRequest"
        case .RejectPromise:
            return "/promise/rejectPromiseRequest"
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
        case .AcceptPromise:
            return .post
        case .RejectPromise:
            return .post
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
        case .AcceptPromise(let id):
            return .requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
        case .RejectPromise(let id):
            return .requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        headers["Authorization"] = "Bearer \(UserSession.shared.token)"
        return headers
        
    }
    
}
