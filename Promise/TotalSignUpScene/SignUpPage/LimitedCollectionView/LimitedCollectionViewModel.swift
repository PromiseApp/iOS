import UIKit
import Photos
import RxSwift
import RxCocoa
import RxFlow

class LimitedViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let leftButtonTapped = PublishRelay<Void>()
    let itemSelected = PublishRelay<Void>()
    
    let photos = BehaviorRelay<[PHAsset]>(value: [])
    var selectedPhoto: PublishSubject<UIImage> = PublishSubject()
    
    init() {
        fetchLimitedPhotos()
        
        leftButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(SignupStep.dismissView)
            })
            .disposed(by: disposeBag)
        
        itemSelected
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(SignupStep.dismissView)
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
