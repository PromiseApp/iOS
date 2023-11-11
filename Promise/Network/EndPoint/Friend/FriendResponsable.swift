import Foundation

struct FriendListResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: FriendList
}

struct FriendList: Codable{
    let list:[FriendData]
}

struct FriendData:Codable{
    let level: String
    let nickname: String
    let img: String?
    let account: String
    let exp: String
}

struct RequestFriendListResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: RequestFriendList
}

struct RequestFriendList: Codable{
    let info: [RequestFriendData]
}

struct RequestFriendData: Codable{
    let memberInfo: MemberInfo
    let requestInfo: RequestInfo
}

struct MemberInfo: Codable{
    let memberId: Int
    let nickname: String
    let level: Int
    let img: String?
}

struct RequestInfo: Codable{
    let id: String
    let requester: String
    let respondent: String
    let accepted: String
}

struct RequestFriendResponse: Codable{
    let resultCode: String
    let resultMessage: String
}
