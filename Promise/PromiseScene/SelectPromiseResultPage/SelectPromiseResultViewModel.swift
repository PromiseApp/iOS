//
//  SelectResultViewModel.swift
//  Promise
//
//  Created by 박중선 on 2023/11/05.
//

import Foundation
import RxCocoa
import RxSwift
import RxFlow

class SelectPromiseResultViewModel: Stepper{
    let disposeBag = DisposeBag()
    let vwaDisposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    var promiseIDViewModel: PromiseIDViewModel
    var promiseService: PromiseService

    let leftButtonTapped = PublishRelay<Void>()
    let selectMemberResultButtonTapped = PublishRelay<String>()
    
    let notDetPromiseRelay = BehaviorRelay<[PromiseHeader]>(value: [])
    var notDetPromiseDriver: Driver<[PromiseHeader]>{
        return notDetPromiseRelay.asDriver(onErrorDriveWith: .empty())
    }
    
    init(promiseIDViewModel: PromiseIDViewModel, promiseService: PromiseService){
        self.promiseIDViewModel = promiseIDViewModel
        self.promiseService = promiseService
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
        selectMemberResultButtonTapped
            .subscribe(onNext: { [weak self] id in
                self?.steps.accept(PromiseStep.selectMemberResult)
                self?.promiseIDViewModel.promiseIdRelay.accept(id)
            })
            .disposed(by: disposeBag)
        
    }
    
    func toggleSectionExpansion(at section: Int) {
        var currentPromises = notDetPromiseRelay.value
        currentPromises[section].isExpanded.toggle()
        notDetPromiseRelay.accept(currentPromises)
    }
    
    func loadNotDetPromiseList(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let nowDateTime = formatter.string(from: Date())
        self.promiseService.promiseList(startDateTime: "2023-01-01 12:00:00", endDateTime: nowDateTime, completed: "N")
            .subscribe(onSuccess: { [weak self] response in
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

                self?.notDetPromiseRelay.accept(promiseHeaders)
            }, onFailure: { [weak self] error in
                self?.steps.accept(PromiseStep.networkErrorPopup)
            })
            .disposed(by: vwaDisposeBag)
    }
    
}
