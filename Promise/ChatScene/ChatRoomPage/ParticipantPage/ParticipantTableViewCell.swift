import UIKit
import SnapKit
import Then

class ParticipantTableViewCell: UITableViewCell {
    
    lazy var userImageView = UIImageView()
    lazy var nameLabel = UILabel()
    lazy var levelLabel = UILabel()
    let leaderImageView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        attribute()
        layout()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        leaderImageView.do{
            $0.image = UIImage(named: "leader")
        }
    }
    
    private func layout(){
        [userImageView,nameLabel,levelLabel,leaderImageView]
            .forEach{ contentView.addSubview($0)}
        
        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(12*Constants.standardWidth)
            make.centerY.equalTo(userImageView)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel.snp.trailing).offset(6*Constants.standardWidth)
            make.centerY.equalTo(userImageView)
        }
        
        leaderImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalTo(levelLabel.snp.trailing).offset(4*Constants.standardWidth)
            make.centerY.equalTo(userImageView)
        }
    }
    
    func configure(with model: Friend) {
        userImageView.image = model.userImage
        nameLabel.text = model.name
        levelLabel.text = "Lv " + model.level
        leaderImageView.isHidden = !model.isSelected
    }
    
}
