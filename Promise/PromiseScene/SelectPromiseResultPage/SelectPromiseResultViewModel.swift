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
    let steps = PublishRelay<Step>()

    let leftButtonTapped = PublishRelay<Void>()
    let selectMemberResultButtonTapped = PublishRelay<Void>()
    
    let resultPromiseRelay = BehaviorRelay<[PromiseHeader]>(value: [])
    let resultPromiseDriver: Driver<[PromiseHeader]>
    
    init(){
        
        let promiseView: [PromiseCell] = [
            .init(time: "10:10", title: "아아아아아아아아아아아아아아아아아아아아", cnt: 3, place: "서울", penalty: "아아아아아아아아아아아아아아아아아아아아",manager: true),
            .init(time: "10:30", title: "bbb", cnt: 2, place: nil, penalty: "qweqwe",manager: false),
            .init(time: "13:10", title: "ccc", cnt: 5, place: "부산", penalty: "yhtyht",manager: true),
        ]
        resultPromiseRelay.accept(
            [
                PromiseHeader(date: "2023-10-3", promises: promiseView, cntPromise: promiseView.count),
                PromiseHeader(date: "2023-10-6", promises: promiseView, cntPromise: promiseView.count),
                PromiseHeader(date: "2023-10-9", promises: promiseView, cntPromise: promiseView.count)
            ]
        )
        
        resultPromiseDriver = resultPromiseRelay.asDriver(onErrorDriveWith: .empty())
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.popView)
            })
            .disposed(by: disposeBag)
        
        selectMemberResultButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(PromiseStep.selectMemberResult)
            })
            .disposed(by: disposeBag)
        
    }
    
    func toggleSectionExpansion(at section: Int) {
        var currentPromises = resultPromiseRelay.value
        currentPromises[section].isExpanded.toggle()
        resultPromiseRelay.accept(currentPromises)
    }
    
}
