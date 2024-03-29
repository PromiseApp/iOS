import Foundation
import RealmSwift
import RxCocoa
import RxSwift
import RxFlow

class PromiseViewModel: Stepper{
    let disposeBag = DisposeBag()
    var vwaDisposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var promiseService: PromiseService
    
    let yearAndMonth = BehaviorRelay<(year: Int?, month: Int?)>(value: (Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date())))
    
    let plusButtonTapped = PublishRelay<Void>()
    let viewPastPromiseButtonTapped = PublishRelay<Void>()
    let selectPromiseResultButtonTapped = PublishRelay<Void>()
    let modifyButtonTapped = PublishRelay<(id: String, type: String)>()
    let newPromiseButtonTapped = PublishRelay<Void>()
    
    let dataLoading = PublishRelay<Bool>()
    let promisesRelay = BehaviorRelay<[PromiseHeader]>(value: [])
    var promiseDriver: Driver<[PromiseHeader]>{
        return promisesRelay.asDriver(onErrorDriveWith: .empty())
    }
    let cntNotDetPromise = BehaviorRelay<Int>(value: 0)
    let levelRelay = PublishRelay<Int>()
    let expRelay = PublishRelay<Int>()
    
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
            .subscribe(onNext: { [weak self] (promiseId, type) in
                self?.steps.accept(PromiseStep.modifyPromise(promiseId: promiseId, type: type))
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
                            let location = item.location ?? "미정"
                            let penalty = item.penalty ?? "미정"
                            let memo = item.memo ?? "미정"
                            let user = DatabaseManager.shared.fetchUser()
                            return PromiseCell(id: item.id, date: date, time: time, title: item.title, place: location, penalty: penalty, memo: memo, manager: user!.nickname == item.leader ? true : false)
                        }

                        let groupedPromises = Dictionary(grouping: promises, by: { $0.date })
                        let promiseHeaders = groupedPromises.map { date, promises -> PromiseHeader in
                            PromiseHeader(date: date, promises: promises, cntPromise: promises.count)
                        }.sorted { $0.date < $1.date }

                        self.promisesRelay.accept(promiseHeaders)
                        self.dataLoading.accept(true)
                        return Void()
                    }
                    .catch { [weak self] error in
                        print(error)
                        self?.dataLoading.accept(true)
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
    
    func loadLevelExp(){
        self.promiseService.GetUserData()
            .subscribe(onSuccess: { [weak self] response in
                self?.levelRelay.accept(response.data.userInfo.level)
                self?.expRelay.accept(response.data.userInfo.exp)
            }, onFailure: { [weak self] error in
                self?.steps.accept(PromiseStep.networkErrorPopup)
            })
            .disposed(by: vwaDisposeBag)
    }
    
    func loadNewPromiseList() {
        self.promiseService.newPormiseList()
            .subscribe(onSuccess: { [weak self] response in
                let newPromises = response.data.list.map { item -> NewPromiseCell in
                    let dateTimeComponents = item.date.split(separator: " ")
                    let date = String(dateTimeComponents[0])
                    let timeWithSeconds = dateTimeComponents[1]
                    let time = String(timeWithSeconds.split(separator: ":")[0...1].joined(separator: ":"))

                    return NewPromiseCell(id: item.id, date: date, time: time, title: item.title, place: item.location, penalty: item.penalty,memo: item.memo)
                }
                self?.compareWithStoredPromises(newPromises: newPromises)
            }, onFailure: { [weak self] error in
                print("promiseService.newPormiseLis",error)
                self?.dataLoading.accept(true)
                self?.steps.accept(PromiseStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
    func compareWithStoredPromises(newPromises: [NewPromiseCell]) {
        let realm = try! Realm()
        let storedPromises = realm.objects(RequestNewPromiseModel.self)
        let storedNewPromiseID = Set(storedPromises.map { $0.newPromiseID })
        
        let isNewPromiseRequest = newPromises.contains { !storedNewPromiseID.contains($0.id) }
        
        if isNewPromiseRequest {
            NotificationCenter.default.post(name: Notification.Name("newPromiseRequestNotificationReceived"), object: nil)
            addNewPromiseToRealm(newPromises)
        }
    }
    
    func addNewPromiseToRealm(_ newPromises: [NewPromiseCell]) {
        let realm = try! Realm()
        try! realm.write {
            for newPromise in newPromises {
                let promiseModel = RequestNewPromiseModel()
                promiseModel.newPromiseID = newPromise.id
                realm.add(promiseModel, update: .modified)
            }
        }
    }
}
