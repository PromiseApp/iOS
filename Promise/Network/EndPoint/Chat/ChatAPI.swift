import Foundation
import Moya

enum ChatAPI {
    case chatList
}

extension ChatAPI: TargetType {

    var baseURL: URL {
        return URL(string: "http://43.200.141.247:8080")!
    }
    
    var path: String {
        switch self {
        case .chatList:
            return "/chat/room/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .chatList:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .chatList:
            return .requestPlain
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
