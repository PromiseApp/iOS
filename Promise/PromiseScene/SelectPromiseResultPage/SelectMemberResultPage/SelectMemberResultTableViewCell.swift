import UIKit
import RxSwift
import SnapKit
import Then

class SelectMemberResultTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()
    
    lazy var userImageView = UIImageView()
    lazy var nameLabel = UILabel()
    lazy var levelLabel = UILabel()
    let failButton = UIButton()
    let successButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        attribute()
        layout()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    private func attribute(){
        userImageView.do{
            $0.layer.cornerRadius = 24*Constants.standardHeight / 2
            $0.sizeToFit()
            $0.clipsToBounds = true
        }
        
        nameLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
        }
        
        levelLabel.do{
            $0.textColor = UIColor(named: "prHeavy")
            $0.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
        }
        
        failButton.do{
            $0.setTitle("실패", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 16*Constants.standardHeight
        }
        
        successButton.do{
            $0.setTitle("성공", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 16*Constants.standardHeight
        }
        
    }
    
    private func layout(){
        [userImageView,nameLabel,levelLabel,successButton,failButton]
            .forEach{ contentView.addSubview($0)}
        
        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalToSuperview().offset(12*Constants.standardHeight)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(12*Constants.standardWidth)
            make.centerY.equalTo(userImageView)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(6*Constants.standardWidth)
            make.centerY.equalTo(userImageView)
        }
        
        successButton.snp.makeConstraints { make in
            make.width.equalTo(55*Constants.standardWidth)
            make.height.equalTo(32*Constants.standardHeight)
            make.trailing.equalTo(contentView.snp.trailing).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(userImageView)
        }
        
        failButton.snp.makeConstraints { make in
            make.width.equalTo(55*Constants.standardWidth)
            make.height.equalTo(32*Constants.standardHeight)
            make.trailing.equalTo(successButton.snp.leading).offset(-8*Constants.standardWidth)
            make.centerY.equalTo(userImageView)
        }
    }
    
    func configure(with model: Friend) {
        userImageView.image = model.userImage
        nameLabel.text = model.name
        levelLabel.text = "Lv " + model.level
    }
    
}
