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
    let author: String
    let title: String
    let content: String
    let createdDate: String
    let statusType: String
    let replies: [Replies]
}

struct Replies: Codable {
    let id: Int
    let author: String
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
    let noticeList: [NoticeList]
}

struct NoticeList: Codable {
    let id: Int
    let title: String
    let content: String
    let createdDate: String
    let postType: String
}
