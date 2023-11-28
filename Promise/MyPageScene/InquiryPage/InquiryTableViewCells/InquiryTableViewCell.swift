import UIKit
import SnapKit
import Then

class InquiryTableViewCell: UITableViewCell {

    let backView = UIView()
    let bottomRightImageView = UIImageView()
    let replyLabel = UILabel()
    let dateLabel = UILabel()
    
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
        
        bottomRightImageView.do{
            $0.image = UIImage(named: "bottomRight")
        }
        
        backView.do{
            $0.backgroundColor = UIColor(named: "prLight")
        }
        
        replyLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.text = "PlaMeet이 답변을 남겼습니다:)"
        }
        
        dateLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)
        }
        
    }
    
    func layout(){
        [backView,bottomRightImageView]
            .forEach{ contentView.addSubview($0)}
        
        [replyLabel,dateLabel]
            .forEach{backView.addSubview($0)}
        
        backView.snp.makeConstraints { make in
            make.width.equalTo(323*Constants.standardWidth)
            make.height.equalTo(49*Constants.standardHeight)
            make.leading.equalToSuperview().offset(40*Constants.standardWidth)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
                       
        bottomRightImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.centerY.equalTo(backView)
        }
        
        replyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(8*Constants.standardHeight)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(replyLabel.snp.bottom).offset(4*Constants.standardHeight)
        }
        
    }
    
    func configure(date: String){
        dateLabel.text = date
    }
   
}
