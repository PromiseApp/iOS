import Foundation
import RxSwift
import RxCocoa
import RxFlow

class PastPromiseViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let leftButtonTapped = PublishRelay<Void>()
    
    let yearAndMonth: BehaviorSubject<(year: Int?, month: Int?)> = BehaviorSubject(value: (Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date())))
    
    let pastPromisesRelay = BehaviorRelay<[GetPastPromise]>(value: [])
    let pastPromiseDatas: Driver<[GetPastPromise]>
    var allPromises: [GetPastPromise] = []
    
    init(){
        pastPromiseDatas = pastPromisesRelay.asDriver(onErrorDriveWith: .empty())
        
        let promiseView: [PastPromiseList] = [
            .init(time: "5:00", title: "qwe", friends: "aa bb cc", place: nil, penalty: "qweqwzx", memo: "erngkjer"),
            .init(time: "9:00", title: "asd", friends: "aa bb cc", place: "ertert", penalty: "qweqweqwerqweqweqwerqweqweqwer", memo: "qweqweqwerqweqweqwerqweqweqwer"),
            .init(time: "15:00", title: "zxc", friends: "aa bb cc", place: nil, penalty: nil, memo: "er"),
        ]
        allPromises = [
            GetPastPromise(date: "2023-10-3", promises: promiseView, cntPromise: promiseView.count),
            GetPastPromise(date: "2023-10-6", promises: promiseView, cntPromise: promiseView.count),
            GetPastPromise(date: "2023-10-9", promises: promiseView, cntPromise: promiseView.count)
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
        
        let filteredPromises = allPromises.map { datePromise -> GetPastPromise in
            let filteredItems = datePromise.promises.filter { $0.title.contains(query) }
            return GetPastPromise(date: datePromise.date, promises: filteredItems, cntPromise: filteredItems.count)
        }.filter { !$0.promises.isEmpty }
        
        pastPromisesRelay.accept(filteredPromises)
    }

    
    func toggleSectionExpansion(at section: Int) {
        var currentPromises = pastPromisesRelay.value
        currentPromises[section].isExpanded.toggle()
        pastPromisesRelay.accept(currentPromises)
    }
    
}
