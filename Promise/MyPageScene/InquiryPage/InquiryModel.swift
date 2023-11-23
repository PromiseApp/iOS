struct InquiryHeader {
    let id: String
    let title: String
    let date: String
    let inquiryReplyDate: InquiryReplyDate?
    var reply: Bool
}

struct InquiryReplyDate {
    let date: String
}

struct DetailInquiry{
    let title: String
    let writer: String
    let content: String
    let reply: String?
}
