import Foundation
import Moya

enum FriendAPI {
    case FriendList
    case RequestedFriendList
    case RequestFriend(respondent: String)
    case RequestFriendAccept(requestId: String)
    case RequestFriendReject(requestId: String)
}

extension FriendAPI: TargetType {

    var baseURL: URL {
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .FriendList:
            return "/friend/getList"
        case .RequestedFriendList:
            return "/friend/requestList"
        case .RequestFriend:
            return "/friend/request"
        case .RequestFriendAccept:
            return "/friend/acceptRequest"
        case .RequestFriendReject:
            return "/friend/rejectRequest"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .FriendList:
            return .get
        case .RequestedFriendList:
            return .get
        case .RequestFriend:
            return .post
        case .RequestFriendAccept:
            return .post
        case .RequestFriendReject:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .FriendList:
            return .requestPlain
        case .RequestedFriendList:
            return .requestPlain
        case .RequestFriend(let respondent):
            return .requestParameters(parameters: ["respondent": respondent], encoding: JSONEncoding.default)
        case .RequestFriendAccept(let requestId):
            return .requestParameters(parameters: ["requestId": requestId], encoding: JSONEncoding.default)
        case .RequestFriendReject(let requestId):
            return .requestParameters(parameters: ["requestId": requestId], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        var headers = ["Content-Type": "application/json"]
        if let user = DatabaseManager.shared.fetchUser(){
            headers["Authorization"] = "Bearer \(user.token)"
        }
        return headers
    }
    
}
