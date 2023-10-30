import Foundation
import RxCocoa
import RxSwift
import RxFlow

class PromiseViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let yearAndMonth: BehaviorSubject<(year: Int?, month: Int?)> = BehaviorSubject(value: (Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date())))
    
    let plusButtonTapped = PublishRelay<Void>()
    let viewPastPromiseButtonTapped = PublishRelay<Void>()
    
    let promisesRelay = BehaviorRelay<[PromiseHeader]>(value: [])
    let cntPromise = BehaviorRelay<Int>(value: 0)
    let promiseDriver: Driver<[PromiseHeader]>
    
    init(){
        
        let promiseView: [PromiseCell] = [
            .init(time: "10:10", title: "아아아아아아아아아아아아아아아아아아아아", cnt: 3, place: "서울", penalty: "아아아아아아아아아아아아아아아아아아아아"),
            .init(time: "10:30", title: "bbb", cnt: 2, place: nil, penalty: "qweqwe"),
            .init(time: "13:10", title: "ccc", cnt: 5, place: "부산", penalty: "yhtyht"),
        ]
        promisesRelay.accept(
            [
                PromiseHeader(date: "2023-10-3", promises: promiseView, cntPromise: promiseView.count),
                PromiseHeader(date: "2023-10-6", promises: promiseView, cntPromise: promiseView.count),
                PromiseHeader(date: "2023-10-9", promises: promiseView, cntPromise: promiseView.count)
            ]
        )
        
        cntPromise.accept(promisesRelay.value.map { $0.cntPromise }.reduce(0, +))
        
        promiseDriver = promisesRelay.asDriver(onErrorDriveWith: .empty())
        
        plusButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.makePromise)
            })
            .disposed(by: disposeBag)
        
        viewPastPromiseButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.pastPromise)
            })
            .disposed(by: disposeBag)
        
    }
    
    func toggleSectionExpansion(at section: Int) {
        var currentPromises = promisesRelay.value
        currentPromises[section].isExpanded.toggle()
        promisesRelay.accept(currentPromises)
    }
    
}
