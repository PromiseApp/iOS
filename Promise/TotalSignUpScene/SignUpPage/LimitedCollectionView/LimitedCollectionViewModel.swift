import UIKit
import Photos
import RxSwift
import RxCocoa
import RxFlow

class LimitedViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let currentFlow: FlowType
    
    let leftButtonTapped = PublishRelay<Void>()
    let itemSelected = PublishRelay<Void>()
    
    let photos = BehaviorRelay<[PHAsset]>(value: [])
    var selectedPhoto = PublishSubject<UIImage>()
    
    init(currentFlow: FlowType) {
        self.currentFlow = currentFlow
        
        fetchLimitedPhotos()
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow {
                case .singupFlow:
                    self?.steps.accept(SignupStep.dismissView)
                case .findPwFlow:
                    break
                case .myPageFlow:
                    self?.steps.accept(MyPageStep.dismissView)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        itemSelected
            .subscribe(onNext: { [weak self] in
                switch self?.currentFlow {
                case .singupFlow:
                    self?.steps.accept(SignupStep.dismissView)
                case .findPwFlow:
                    break
                case .myPageFlow:
                    self?.steps.accept(MyPageStep.dismissView)
                case .none:
                    break
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func fetchLimitedPhotos() {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary]
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assetsFetchResult = PHAsset.fetchAssets(with: fetchOptions)
        var assets: [PHAsset] = []
        assetsFetchResult.enumerateObjects { (asset, _, _) in
            assets.append(asset)
        }
        self.photos.accept(assets)
    }
}
