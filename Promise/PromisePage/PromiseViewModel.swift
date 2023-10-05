import Foundation
import RxCocoa
import RxSwift

class PromiseViewModel{
    let yearAndMonth: BehaviorSubject<(year: Int, month: Int)> = BehaviorSubject(value: (Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date())))

    let promisesRelay = BehaviorRelay<[GetPromise]>(value: [])
    let cntPromise = BehaviorRelay<Int>(value: 0)
    let promiseDatas: Driver<[GetPromise]>
    
    init(){
        
        let promiseView: [PromiseView] = [
            .init(time: "10:10", title: "aaa", cnt: 3, place: "서울", penalty: "asdasd"),
            .init(time: "10:30", title: "bbb", cnt: 2, place: nil, penalty: "qweqwe"),
            .init(time: "13:10", title: "ccc", cnt: 5, place: "부산", penalty: "yhtyht"),
        ]
        promisesRelay.accept(
            [
                GetPromise(date: "2023-10-3", promises: promiseView, cntPromise: promiseView.count),
                GetPromise(date: "2023-10-6", promises: promiseView, cntPromise: promiseView.count),
                GetPromise(date: "2023-10-9", promises: promiseView, cntPromise: promiseView.count)
            ]
        )
        
        cntPromise.accept(promisesRelay.value.map { $0.cntPromise }.reduce(0, +))
        
        promiseDatas = promisesRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    func toggleSectionExpansion(at section: Int) {
        var currentPromises = promisesRelay.value
        currentPromises[section].isExpanded.toggle()
        promisesRelay.accept(currentPromises)
    }
    
}
