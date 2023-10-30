import UIKit
import SnapKit
import Then

class AnnouncementTableViewCell: UITableViewCell {

    let backView = UIView()
    let contentLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute(){
        
        backView.do{
            $0.backgroundColor = UIColor(named: "prLight")
        }
        
        contentLabel.do{
            $0.numberOfLines = 0
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
        }
        
    }
    
    func layout(){
        contentView.addSubview(backView)
        backView.addSubview(contentLabel)
        
        backView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(contentLabel.snp.height).offset(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalToSuperview().offset(8*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-8*Constants.standardHeight)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.width.equalTo(327*Constants.standardWidth)
            make.centerY.centerX.equalToSuperview()
        }
        
    }
    
    func configure(content: String){
        contentLabel.text = content
    }
   
}
