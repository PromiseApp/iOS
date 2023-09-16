import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class FriendCollectionViewCell: UICollectionViewCell {
    
    let userImageView = UIImageView()
    let nameLabel = UILabel()
    let deleteButton = UIButton()
    
    let disposeBag = DisposeBag()
    let deleteButtonTapped = PublishSubject<Void>()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func attribute(){
        backgroundColor = UIColor(named: "prNormal")
        layer.cornerRadius = 8*Constants.standardHeight
        
        userImageView.do{
            $0.layer.cornerRadius = $0.frame.size.height / 2
        }
        
        nameLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 11*Constants.standartFont)
        }
        
        deleteButton.do{
            $0.layer.cornerRadius = $0.frame.size.height / 2
            $0.setImage(UIImage(named: "clear"), for: .normal)
            $0.rx.tap
                .bind(to: deleteButtonTapped)
                .disposed(by: disposeBag)
        }
       

    }
    
    func layout(){
        [userImageView,nameLabel,deleteButton]
            .forEach{ contentView.addSubview($0) }
        
        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.top.equalToSuperview().offset(4*Constants.standardHeight)
            make.centerX.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(4*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-4*Constants.standardHeight)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.width.height.equalTo(12*Constants.standardHeight)
            make.top.trailing.equalToSuperview()
        }

    }
    
    func configure(with model: Friend) {
        userImageView.image = model.userImage
        nameLabel.text = model.name
    }
}
