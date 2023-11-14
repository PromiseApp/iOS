import Foundation
import RxSwift
import RxCocoa
import RxFlow

class PastPromiseViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let leftButtonTapped = PublishRelay<Void>()
    
    let yearAndMonth: BehaviorSubject<(year: Int?, month: Int?)> = BehaviorSubject(value: (Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date())))
    
    var pastPromisesRelay = BehaviorRelay<[PromiseHeader]>(value: [])
    var pastPromiseDatas: Driver<[PromiseHeader]>
    var allPromises: [PromiseHeader] = []
    
    init(){
        pastPromiseDatas = pastPromisesRelay.asDriver(onErrorDriveWith: .empty())
        
//        let promiseView: [PromiseCell] = [
//            .init(id: "1", time: "10:10", title: "아아아아아아아아아아아아아아아아아아아아", place: "서울", penalty: "아아아아아아아아아아아아아아아아아아아아",memo: "12", manager: false),
//            .init(id: "2", time: "10:30", title: "bbb", place: nil, penalty: "qweqwe",memo: "12", manager: true),
//            .init(id: "3", time: "13:10", title: "ccc", place: "부산", penalty: "yhtyht",memo: "12", manager: true),
//        ]
//        
//        allPromises = [
//            PromiseHeader(date: "2023-10-3", promises: promiseView, cntPromise: promiseView.count),
//            PromiseHeader(date: "2023-10-6", promises: promiseView, cntPromise: promiseView.count),
//            PromiseHeader(date: "2023-10-9", promises: promiseView, cntPromise: promiseView.count)
//        ]
        
        pastPromisesRelay.accept(allPromises)
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
    }
    
    func search(query: String?) {
        guard let query = query, !query.isEmpty else {
            pastPromisesRelay.accept(allPromises)
            return
        }
        
        let filteredPromises = allPromises.map { datePromise -> PromiseHeader in
            let filteredItems = datePromise.promises.filter { $0.title.contains(query) }
            return PromiseHeader(date: datePromise.date, promises: filteredItems, cntPromise: filteredItems.count)
        }.filter { !$0.promises.isEmpty }
        
        pastPromisesRelay.accept(filteredPromises)
    }
    
    func toggleSectionExpansion(at section: Int) {
        var currentPromises = pastPromisesRelay.value
        currentPromises[section].isExpanded.toggle()
        pastPromisesRelay.accept(currentPromises)
    }
    
}
