import Foundation

struct PromiseHeader{
    let date: String
    let promises: [PromiseCell]
    let cntPromise: Int
    var isExpanded: Bool = false
}

struct PromiseCell{
    let id: String
    let date: String
    let time: String
    let title: String
    let place: String?
    let penalty: String?
    let memo: String?
    let manager: Bool
}

struct NewPromiseHeader{
    let date: String
    var newPromises: [NewPromiseCell]
    let cntPromise: Int
    var isExpanded: Bool = false
}

struct NewPromiseCell{
    let id: String
    let date: String
    let time: String
    let title: String
    let place: String?
    let penalty: String?
    let memo: String?
    var isSelected: Bool = false
}
