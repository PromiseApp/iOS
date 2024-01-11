import UIKit
import RxCocoa
import Kingfisher

class ImageDownloadManager {
    static let shared = ImageDownloadManager()
    
    func downloadImage(urlString: String?, imageRelay: BehaviorRelay<UIImage?>) {
            guard let urlString = urlString, let url = URL(string: urlString), !urlString.isEmpty else {
                imageRelay.accept(UIImage(named: "user"))
                return
            }
            
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResult):
                    imageRelay.accept(imageResult.image)
                case .failure(let error):
                    print("Image download error: \(error)")
                    imageRelay.accept(UIImage(named: "user"))
                }
            }
        }
}
