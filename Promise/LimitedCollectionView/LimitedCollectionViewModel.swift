import UIKit
import Photos
import RxSwift
import RxCocoa

class LimitedViewModel{
    let photos = BehaviorRelay<[PHAsset]>(value: [])
    var selectedPhoto: PublishSubject<UIImage> = PublishSubject()
    
    init() {
            fetchLimitedPhotos()
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
