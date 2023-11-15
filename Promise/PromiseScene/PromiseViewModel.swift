import Foundation
import RxCocoa
import RxSwift
import RxFlow

class PromiseViewModel: Stepper{
    let disposeBag = DisposeBag()
    let vwaDisposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var promiseService: PromiseService
    
    let yearAndMonth = BehaviorRelay<(year: Int?, month: Int?)>(value: (Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date())))
    
    let plusButtonTapped = PublishRelay<Void>()
    let viewPastPromiseButtonTapped = PublishRelay<Void>()
    let selectPromiseResultButtonTapped = PublishRelay<Void>()
    let modifyButtonTapped = PublishRelay<(id: String, isManager: Bool)>()
    let newPromiseButtonTapped = PublishRelay<Void>()
    
    let promisesRelay = BehaviorRelay<[PromiseHeader]>(value: [])
    var promiseDriver: Driver<[PromiseHeader]>{
        return promisesRelay.asDriver(onErrorDriveWith: .empty())
    }
    let cntNotDetPromise = BehaviorRelay<Int>(value: 0)
    
    
    init(promiseService: PromiseService){
        self.promiseService = promiseService
        
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
        
        selectPromiseResultButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.selectPromiseResult)
            })
            .disposed(by: disposeBag)
        
        modifyButtonTapped
            .subscribe(onNext: { [weak self] (id, isManager) in
                //self?.steps.accept(PromiseStep.modifyPromise(id: id, isManager: isManager))
            })
            .disposed(by: disposeBag)
        
        newPromiseButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.newPromise)
            })
            .disposed(by: disposeBag)
        
    }
    
    func toggleSectionExpansion(at section: Int) {
        var currentPromises = promisesRelay.value
        currentPromises[section].isExpanded.toggle()
        promisesRelay.accept(currentPromises)
    }
    
    func loadPromiseList(){
        yearAndMonth
            .flatMapLatest { year, month -> Observable<Void> in
                guard let year = year, let month = month else { return Observable.empty()}
                
                let startDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))
                let nowDate = Date()
                let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startDate!)!)
                
                let startComponents = Calendar.current.dateComponents([.year, .month], from: startDate!)
                let midComponents = Calendar.current.dateComponents([.year, .month], from: nowDate)

                var realStartDate = startDate
                if startComponents.year == midComponents.year && startComponents.month == midComponents.month {
                    realStartDate = nowDate
                }

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let startDateTime = formatter.string(from: realStartDate!)
                let endDateTime = formatter.string(from: endDate!)
                return self.promiseService.promiseList(startDateTime: startDateTime, endDateTime: endDateTime, completed: "N")
                    .asObservable()
                    .map{ response in
                        let promises = response.data.list.map { item -> PromiseCell in
                            let dateTimeComponents = item.date.split(separator: " ")
                            let date = String(dateTimeComponents[0])
                            let time = String(dateTimeComponents[1].split(separator: ":")[0...1].joined(separator: ":"))

                            return PromiseCell(id: item.id, date: date, time: time, title: item.title, place: item.location, penalty: item.penalty, memo: item.memo, manager: UserSession.shared.nickname == item.leader ? true : false)
                        }

                        let groupedPromises = Dictionary(grouping: promises, by: { $0.date })
                        let promiseHeaders = groupedPromises.map { date, promises -> PromiseHeader in
                            PromiseHeader(date: date, promises: promises, cntPromise: promises.count)
                        }.sorted { $0.date < $1.date }

                        self.promisesRelay.accept(promiseHeaders)
                        return Void()
                    }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(PromiseStep.networkErrorPopup)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { _ in
                
            })
            .disposed(by: vwaDisposeBag)
    }

    func loadNotDetPromiseList(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowDateTime = formatter.string(from: Date())
        self.promiseService.promiseList(startDateTime: "2023-01-01 12:00:00", endDateTime: nowDateTime, completed: "N")
            .subscribe(onSuccess: { [weak self] response in
                self?.cntNotDetPromise.accept(response.data.list.count)
            }, onFailure: { [weak self] error in
                self?.steps.accept(PromiseStep.networkErrorPopup)
            })
            .disposed(by: vwaDisposeBag)
    }
    
}

//let now = Date()
//let year = Calendar.current.component(.year, from: Date())
//let month = Calendar.current.component(.month, from: Date())
//let startDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))
//let midDate = now
//let endDate = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startDate!)
//
//let formatter = DateFormatter()
//formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//let startDateTime = formatter.string(from: startDate!)
//let midDateTime = formatter.string(from: midDate)
//let endDateTime = formatter.string(from: endDate!)
