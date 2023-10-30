import Foundation
import RxSwift
import RxCocoa
import RxFlow

class PastPromiseViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let leftButtonTapped = PublishRelay<Void>()
    
    let yearAndMonth: BehaviorSubject<(year: Int?, month: Int?)> = BehaviorSubject(value: (Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date())))
    
    let pastPromisesRelay = BehaviorRelay<[PastPromiseHeader]>(value: [])
    let pastPromiseDatas: Driver<[PastPromiseHeader]>
    var allPromises: [PastPromiseHeader] = []
    
    init(){
        pastPromiseDatas = pastPromisesRelay.asDriver(onErrorDriveWith: .empty())
        
        let promiseView: [PastPromiseCell] = [
            .init(time: "5:00", title: "qwe", friends: "aa bb cc", place: nil, penalty: "qweqwzx", memo: "erngkjer"),
            .init(time: "9:00", title: "asd", friends: "aa bb cc", place: "ertert", penalty: "qweqweqwerqweqweqwerqweqweqwer", memo: "qweqweqwerqweqweqwerqweqweqwer"),
            .init(time: "15:00", title: "zxc", friends: "aa bb cc", place: nil, penalty: nil, memo: "er"),
        ]
        allPromises = [
            PastPromiseHeader(date: "2023-10-3", promises: promiseView, cntPromise: promiseView.count),
            PastPromiseHeader(date: "2023-10-6", promises: promiseView, cntPromise: promiseView.count),
            PastPromiseHeader(date: "2023-10-9", promises: promiseView, cntPromise: promiseView.count)
        ]
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
        
        let filteredPromises = allPromises.map { datePromise -> PastPromiseHeader in
            let filteredItems = datePromise.promises.filter { $0.title.contains(query) }
            return PastPromiseHeader(date: datePromise.date, promises: filteredItems, cntPromise: filteredItems.count)
        }.filter { !$0.promises.isEmpty }
        
        pastPromisesRelay.accept(filteredPromises)
    }

    
    func toggleSectionExpansion(at section: Int) {
        var currentPromises = pastPromisesRelay.value
        currentPromises[section].isExpanded.toggle()
        pastPromisesRelay.accept(currentPromises)
    }
    
}
