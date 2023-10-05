import Foundation

struct GetPromise{
    let date: String
    let promises: [PromiseView]
    let cntPromise: Int
    var isExpanded: Bool = false
}

struct PromiseView{
    let time: String
    let title: String
    let cnt: Int
    let place: String?
    let penalty: String?
}
