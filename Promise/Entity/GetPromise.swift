import Foundation

struct GetPromise{
    let date: String
    let promises: [PromiseList]
    let cntPromise: Int
    var isExpanded: Bool = false
}

struct PromiseList{
    let time: String
    let title: String
    let cnt: Int
    let place: String?
    let penalty: String?
}

struct GetPastPromise{
    let date: String
    let promises: [PastPromiseList]
    let cntPromise: Int
    var isExpanded: Bool = false
}

struct PastPromiseList{
    let time: String
    let title: String
    let friends: String
    let place: String?
    let penalty: String?
    let memo: String?
}
