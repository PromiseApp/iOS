struct MyPageResponse: Codable{
    let resultCode: String
    let resultMessage: String
}

struct InquiryListResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: InquiryListData
}

struct InquiryListData: Codable {
    let inquiryList: [InquiryList]
}

struct InquiryList: Codable {
    let id: Int
    let title: String
    let createdDate: String
    let statusType: String
    let replies: [Replies]
}

struct Replies: Codable {
    let id: Int
    let title: String
    let content: String
    let modifiedDate: String
}

struct NoticeListResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: NoticeData
}

struct NoticeData: Codable {
    var noticeList: [NoticeList]
}

struct NoticeList: Codable {
    var id: Int
    var title: String
    var createdDate: String
    var postType: String
}

struct NoticeDetailResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: NoticeContent
}

struct NoticeContent: Codable {
    var noticeContent: String
}
