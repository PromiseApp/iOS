import RxSwift
import UIKit
import Foundation
import RxCocoa
import RxFlow

class ParticipantViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    let promiseService = PromiseService()
    let promiseID: String
    
    let participantRelay = PublishRelay<[Friend]>()
    var participantDriver: Driver<[Friend]>{
        return participantRelay.asDriver(onErrorJustReturn: [])
    }
    
    init(promiseID: Int) {
        self.promiseID = String(promiseID)
        self.loadParticipant()
    }
    
    func loadParticipant(){
        self.promiseService.detailPromise(promiseId: self.promiseID)
            .subscribe(onSuccess: { [weak self] response in
                let members:[Friend] = response.data.membersInfo.map{ friend in
                    var userImage = UIImage(named: "user")
                    if let imageBase64 = friend.img,
                       let imageData = Data(base64Encoded: imageBase64),
                       let image = UIImage(data: imageData) {
                        userImage = image
                    }
                    if(response.data.promiseInfo.leader == friend.nickname){
                        return Friend(userImage: userImage!, name: friend.nickname, level: friend.level, isSelected: true)
                    }
                    else{
                        return Friend(userImage: userImage!, name: friend.nickname, level: friend.level, isSelected: false)
                    }
                }
                
                self?.participantRelay.accept(members)
            },
            onFailure: { [weak self] error in
                self?.steps.accept(ChatStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
}
