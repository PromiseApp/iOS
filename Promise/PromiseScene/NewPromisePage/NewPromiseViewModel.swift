import Foundation
import RealmSwift
import RxCocoa
import RxSwift
import RxFlow
class NewPromiseViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var promiseService: PromiseService
    var stompService: StompService
    var selectedCellID: String?
    
    let leftButtonTapped = PublishRelay<Void>()
    let absenceButtonTapped = PublishRelay<Void>()
    let participationButtonTapped = PublishRelay<Void>()
    let cellSelected = PublishRelay<IndexPath>()
    let requestSuccessRelay = PublishRelay<String>()
    let dataLoading = PublishRelay<Bool>()
    
    var newPromiseList:[NewPromiseHeader] = []
    let newPromiseRelay = BehaviorRelay<[NewPromiseHeader]>(value: [])
    var newPromiseDriver: Driver<[NewPromiseHeader]>{
        return newPromiseRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    init(promiseService: PromiseService, stompService: StompService){
        self.promiseService = promiseService
        self.stompService = stompService
        self.loadNewPromiseList()
        
        cellSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.updateSelectedCell(at: indexPath)
            })
            .disposed(by: disposeBag)
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
        
        absenceButtonTapped
            .flatMapLatest { [weak self] () -> Observable<Void> in
                guard let self = self, let selectedID = self.selectedCellID else { return Observable.empty() }
                return self.promiseService.rejectPromise(id: selectedID)
                    .asObservable()
                    .map{ response in
                        if(response.resultCode == "424"){
                            self.steps.accept(PromiseStep.errorDeletedPromisePopup)
                        }
                        return Void()
                    }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(PromiseStep.networkErrorPopup)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] in
                guard let self = self, let selectedID = self.selectedCellID else { return }
                self.requestSuccessRelay.accept(selectedID)
            })
            .disposed(by: disposeBag)
        

        participationButtonTapped
            .flatMapLatest { [weak self] () -> Observable<Void> in
                guard let self = self, let selectedID = self.selectedCellID else { return Observable.empty() }
                return self.promiseService.acceptPromise(id: selectedID)
                    .asObservable()
                    .map{ response in
                        let roomID = Int(selectedID)
                        self.stompService.subscribeToChatRoom(promiseID: roomID!)
                        self.saveRoomId(roomId: roomID!)
                        if(response.resultCode == "424"){
                            self.steps.accept(PromiseStep.errorDeletedPromisePopup)
                        }
                        
                        return Void()
                    }
                    .catch { [weak self] error in
                        print(error)
                        self?.steps.accept(PromiseStep.networkErrorPopup)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: { [weak self] in
                guard let self = self, let selectedID = self.selectedCellID else { return }
                self.requestSuccessRelay.accept(selectedID)
            })
            .disposed(by: disposeBag)
        
    }
    
    func toggleSectionExpansion(at section: Int) {
        var currentPromises = newPromiseRelay.value
        currentPromises[section].isExpanded.toggle()
        newPromiseRelay.accept(currentPromises)
    }
    
    private func updateSelectedCell(at indexPath: IndexPath) {
        var currentPromises = newPromiseRelay.value
        if let selectedID = selectedCellID {
            for section in currentPromises.indices {
                for row in currentPromises[section].newPromises.indices {
                    if currentPromises[section].newPromises[row].id == selectedID {
                        currentPromises[section].newPromises[row].isSelected = false
                        break
                    }
                }
            }
        }
        
        currentPromises[indexPath.section].newPromises[indexPath.row].isSelected = true
        selectedCellID = currentPromises[indexPath.section].newPromises[indexPath.row].id
        newPromiseRelay.accept(currentPromises)
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

                let groupedPromises = Dictionary(grouping: newPromises, by: { $0.date })
                let newPromiseHeaders = groupedPromises.map { date, promises -> NewPromiseHeader in
                    NewPromiseHeader(date: date, newPromises: promises, cntPromise: promises.count)
                }.sorted { $0.date < $1.date }
                self?.newPromiseRelay.accept(newPromiseHeaders)
                self?.newPromiseList = newPromiseHeaders
                self?.dataLoading.accept(true)
            }, onFailure: { [weak self] error in
                print(error)
                self?.dataLoading.accept(true)
                self?.steps.accept(PromiseStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
    func saveRoomId(roomId: Int){
        let realm = try! Realm()
        try! realm.write {
            let newChatList = ChatList()
            newChatList.roomId = roomId
            realm.add(newChatList)
        }
    }
    
    
}
