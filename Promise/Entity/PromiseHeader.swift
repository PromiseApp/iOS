import Foundation

struct PromiseHeader{
    let date: String
    let promises: [PromiseCell]
    let cntPromise: Int
    var isExpanded: Bool = false
}

struct PromiseCell{
    let time: String
    let title: String
    let cnt: Int
    let place: String?
    let penalty: String?
    let manager: Bool
}

struct PastPromiseHeader{
    let date: String
    let promises: [PastPromiseCell]
    let cntPromise: Int
    var isExpanded: Bool = false
}

struct PastPromiseCell{
    let time: String
    let title: String
    let friends: String
    let place: String?
    let penalty: String?
    let memo: String?
}
