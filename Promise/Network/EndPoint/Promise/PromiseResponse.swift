struct PromiseResponse: Codable{
    let resultCode: String
    let resultMessage: String
}

struct RegisterPromiseResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: RegisterPromiseData
}

struct RegisterPromiseData: Codable {
    let info: Info
}

struct Info: Codable {
    let id: Int
    let title: String
    let location: String?
    let coordinate: String?
    let penalty: String?
    let leader: String
    let date: String
    let memo: String?
    let completed: String
    let createdDate: String
    let modifiedDate: String
    let members: [Member]
}

struct Member: Codable {
    let nickname: String
    let accepted: String
}

struct PromiseListResponse: Codable{
    let resultCode: String
    let resultMessage: String
    let data: PromiseListData
}

struct PromiseListData: Codable {
    let list: [PromiseListItem]
}

struct PromiseListItem: Codable{
    let location: String?
    let id: String
    let date: String
    let title: String
    let penalty: String?
    let leader: String
    let memo: String?
}

struct NewPromiseListResponse: Codable {
    let resultCode: String
    let resultMessage: String
    let data: NewPromiseListData
}

struct NewPromiseListData: Codable {
    let list: [NewPromiseListItem]
}

struct NewPromiseListItem: Codable {
    let location: String?
    let id: String
    let date: String
    let title: String
    let penalty: String?
    let leader: String
    let memo: String?
}

struct PromiseDetailResponse: Codable {
    let resultCode: String
    let resultMessage: String
    let data: PromiseDetailData
}

struct PromiseDetailData: Codable {
    let membersInfo: [PromiseDetailMemberInfo]
    let promiseInfo: PromiseInfo
}

struct PromiseDetailMemberInfo: Codable {
    let level: String
    let img: String?
    let nickname: String
}

struct PromiseInfo: Codable {
    let id: Int
    let title: String
    let location: String?
    let coordinate: String?
    let penalty: String?
    let leader: String
    let date: String
    let memo: String?
    let completed: String
    let createdDate: String
    let modifiedDate: String
    let members: [PromiseMember]
}

struct PromiseMember: Codable {
    let nickname: String
    let accepted: String
    let isSucceed: String?
}

struct GetUserExp: Codable{
    let resultCode: String
    let resultMessage: String
    let data: UserExpData
}

struct UserExpData: Codable{
    let userInfo: UserExpInfo
}

struct UserExpInfo: Codable{
    let level: Int
    let exp: Int
}
