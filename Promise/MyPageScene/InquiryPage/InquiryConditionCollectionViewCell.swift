import UIKit
import Then

class InquiryConditionCollectionViewCell: UICollectionViewCell {
    
    let conditionLabel = UILabel()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute(){
        backgroundColor = UIColor(named: "prLight")
        
        conditionLabel.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
    }
    
    func layout(){
        contentView.addSubview(conditionLabel)
        
        conditionLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func configure(text: String) {
        conditionLabel.text = text
    }
}
