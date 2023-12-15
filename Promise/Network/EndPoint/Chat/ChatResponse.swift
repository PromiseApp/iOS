struct ChatListResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: ChatRoomListData
}

struct ChatRoomListData: Codable {
    let chatRoomList: [ChatRoomList]
}

struct ChatRoomList: Codable {
    let roomId: Int
    let title: String
    let totalMember: Int
    let promiseDate: String
    let lastSendDate: String?
}
