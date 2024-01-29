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
                var members: [Friend] = []
                let dispatchGroup = DispatchGroup()

                response.data.membersInfo.forEach { friendData in
                    dispatchGroup.enter()
                    var userImage = UIImage(named: "user")
                    
                    let completion = {
                        let friend = Friend(userImage: userImage!, name: friendData.nickname, level: friendData.level, isSelected: response.data.promiseInfo.leader == friendData.nickname)
                        members.append(friend)
                        dispatchGroup.leave()
                    }

                    if let imageUrl = friendData.img {
                        ImageDownloadManager.shared.downloadImage(urlString: imageUrl) { image in
                            userImage = image ?? UIImage(named: "user")!
                            completion()
                        }
                    } else {
                        completion()
                    }
                }

                dispatchGroup.notify(queue: .main) {
                    self?.participantRelay.accept(members)
                }
            },
            onFailure: { [weak self] error in
                self?.steps.accept(ChatStep.networkErrorPopup)
            })
            .disposed(by: disposeBag)
    }
    
}
