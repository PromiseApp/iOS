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
    let id: String
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
    let list: RequestFriendData
}

struct RequestFriendData: Codable{
    let id: String
    let accepted: String
    let respondent: String
    let requester: String
}

struct RequestFriendResponse: Codable{
    let resultCode: String
    let resultMessage: String
}
