import Foundation
import RxSwift
import RxCocoa
import RxFlow

class PastPromiseViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var promiseService: PromiseService
    
    let leftButtonTapped = PublishRelay<Void>()
    let modifyButtonTapped = PublishRelay<(id: String, type: String)>()
    
    let yearAndMonth: BehaviorSubject<(year: Int?, month: Int?)> = BehaviorSubject(value: (Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date())))
    
    var pastPromisesRelay = BehaviorRelay<[PromiseHeader]>(value: [])
    var pastPromiseDatas: Driver<[PromiseHeader]>{
        return pastPromisesRelay.asDriver(onErrorDriveWith: .empty())
    }
    var allPromises: [PromiseHeader] = []
    
    init(promiseService: PromiseService){
        self.promiseService = promiseService
        self.loadPastPromiseList()
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
        modifyButtonTapped
            .subscribe(onNext: { [weak self] (promiseId, type) in
                self?.steps.accept(PromiseStep.modifyPromise(promiseId: promiseId, type: type))
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
    
    func loadPastPromiseList(){
        yearAndMonth
            .flatMapLatest { year, month -> Observable<Void> in
                guard let year = year, let month = month else { return Observable.empty()}
                
                let startDate = Calendar.current.date(from: DateComponents(year: year, month: month, day: 1))
                let nowDate = Date()
                let endDate = Calendar.current.date(bySettingHour: 23, minute: 59, second: 59, of: Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startDate!)!)
                
                let midComponents = Calendar.current.dateComponents([.year, .month], from: nowDate)
                let endComponents = Calendar.current.dateComponents([.year, .month], from: endDate!)

                var realEndDate = endDate
                if midComponents.year == endComponents.year && midComponents.month == endComponents.month {
                    realEndDate = nowDate
                }

                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let startDateTime = formatter.string(from: startDate!)
                let endDateTime = formatter.string(from: realEndDate!)
                return self.promiseService.promiseList(startDateTime: startDateTime, endDateTime: endDateTime, completed: "Y")
                    .asObservable()
                    .map{ response in
                        let promises = response.data.list.map { item -> PromiseCell in
                            let dateTimeComponents = item.date.split(separator: " ")
                            let date = String(dateTimeComponents[0])
                            let time = String(dateTimeComponents[1].split(separator: ":")[0...1].joined(separator: ":"))

                            let location = item.location ?? "미정"
                            let penalty = item.penalty ?? "미정"
                            let memo = item.memo ?? "미정"

                            return PromiseCell(id: item.id, date: date, time: time, title: item.title, place: location, penalty: penalty, memo: memo, manager: UserSession.shared.nickname == item.leader ? true : false)
                        }

                        let groupedPromises = Dictionary(grouping: promises, by: { $0.date })
                        let promiseHeaders = groupedPromises.map { date, promises -> PromiseHeader in
                            PromiseHeader(date: date, promises: promises, cntPromise: promises.count)
                        }.sorted { $0.date < $1.date }
                        self.allPromises = promiseHeaders
                        self.pastPromisesRelay.accept(promiseHeaders)
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
            .disposed(by: disposeBag)
    }
    
}
