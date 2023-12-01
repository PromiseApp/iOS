import Foundation
import Moya

enum MyPageAPI {
    case CreateInquiry(author: String, title: String, content: String, type: String)
    case ReplyInquiry(postId: String, author: String, title: String, content: String)
    case InquiryList(account: String, period: String, statusType: String)
    case NoticeList
    case GetExp
}

extension MyPageAPI: TargetType {

    var baseURL: URL {
        //return URL(string: "http://43.200.141.247:8080")!
        return URL(string: "http://localhost:8080")!
    }
    
    var path: String {
        switch self {
        case .CreateInquiry:
            return "/post/inquiry"
        case .ReplyInquiry:
            return "/post/inquiry/reply"
        case .InquiryList(let account,_,_):
            return "/post/inquiry/list/\(account)"
        case .NoticeList:
            return "/post/notice/all"
        case .GetExp:
            return "/member/info"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .CreateInquiry:
            return .post
        case .ReplyInquiry:
            return .post
        case .InquiryList:
            return .get
        case .NoticeList:
            return .get
        case .GetExp:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .CreateInquiry(let author, let title, let content, let type):
            let parameters = [
                "author": author,
                "title": title,
                "content": content,
                "type": type
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .ReplyInquiry(let postId, let author, let title, let content):
            let parameters = [
                "postId": postId,
                "author": author,
                "title": title,
                "content": content
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .InquiryList(_,let period, let statusType):
            if period != "전체" || statusType != "전체" {
                var parameters: [String: Any] = [:]
                if period != "전체" {
                    parameters["period"] = period
                }
                if statusType != "전체" {
                    parameters["statusType"] = statusType
                }
                return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
            } else {
                return .requestPlain
            }
        case .NoticeList:
            return .requestPlain
        case .GetExp:
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
