import UIKit
import RxSwift
import RxCocoa
import Photos
import SnapKit
import Then

class LimitedViewController: UIViewController {
    
    private let limitedViewModel: LimitedViewModel
    private let disposeBag = DisposeBag()
    weak var signupCoordinator: SignupCoordinator?
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then{
        let screenWidth = UIScreen.main.bounds.width
        let cellWidth = (screenWidth - 4) / 3
        $0.itemSize = CGSize(width: cellWidth, height: cellWidth)
        $0.minimumLineSpacing = 2
        $0.minimumInteritemSpacing = 2
    })
    
    init(limitedViewModel: LimitedViewModel, signupCoordinator: SignupCoordinator?) {
        self.limitedViewModel = limitedViewModel
        self.signupCoordinator = signupCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.shared().register(self)
        
        bind()
        attribute()
        layout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showPickerAlert()
    }
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    
    private func bind() {
        
        leftButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.signupCoordinator?.dismissToVC()
            })
            .disposed(by: disposeBag)
        
        limitedViewModel.photos
            .bind(to: collectionView.rx.items(cellIdentifier: "Cell", cellType: LimitedCollectionViewCell.self)) { index, model, cell in
                PHImageManager.default().requestImage(for: model, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
                    cell.imageView.image = image
                }
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let asset = self?.limitedViewModel.photos.value[indexPath.item]
                PHImageManager.default().requestImage(for: asset!, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFill, options: nil) { image, _ in
                    guard let image = image else { return }
                    self?.limitedViewModel.selectedPhoto.onNext(image)
                    self?.signupCoordinator?.dismissToVC()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "선택된 사진"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        collectionView.register(LimitedCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,collectionView]
            .forEach{ view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20*Constants.standardHeight)
        }
        
        leftButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        separateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom)
        }
    }
    
    private func showPickerAlert() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "더 많은 사진 선택", style: .default, handler: { _ in
            PHPhotoLibrary.requestAuthorization(for: .readWrite){ status in
                if status == .limited {
                    PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: self)
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "현재 선택 항목 유지", style: .cancel))
        present(alert, animated: true, completion: nil)
    }
}

extension LimitedViewController: PHPhotoLibraryChangeObserver{
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.includeAssetSourceTypes = [.typeUserLibrary]
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let assetsFetchResult = PHAsset.fetchAssets(with: fetchOptions)
        var assets: [PHAsset] = []
        assetsFetchResult.enumerateObjects { (asset, _, _) in
            assets.append(asset)
        }
        self.limitedViewModel.photos.accept(assets)
    }
}
