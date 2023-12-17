import UIKit
import SnapKit
import Then

class MyChatTableViewCell: UITableViewCell {

    let myChatLabel = UILabel()
    let chatBackgroundView = UIView()
    let chatDateLabel = UILabel()
    
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
        
        myChatLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.textColor = UIColor.white
            $0.numberOfLines = 0
        }
        
        chatBackgroundView.do{
            $0.backgroundColor = UIColor(named: "prHeavy")
            $0.layer.cornerRadius = 4*Constants.standardHeight
        }
        
        chatDateLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)
        }
    }
    
    func layout(){
        chatBackgroundView.addSubview(myChatLabel)
        contentView.addSubview(chatBackgroundView)
        contentView.addSubview(chatDateLabel)
        
        chatBackgroundView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(250*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.top.equalToSuperview().offset(12*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-12*Constants.standardHeight)
        }
        
        myChatLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.top.equalToSuperview().offset(4*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-4*Constants.standardHeight)
        }
        
        chatDateLabel.snp.makeConstraints { make in
            make.trailing.equalTo(chatBackgroundView.snp.leading).offset(-6*Constants.standardWidth)
            make.bottom.equalTo(chatBackgroundView.snp.bottom)
        }
        
    }
    
    func configure(chat: ChatCell){
        myChatLabel.text = chat.content
        chatDateLabel.text = String(chat.chatDate.dropFirst(5).dropLast(3))
    }
   
}
