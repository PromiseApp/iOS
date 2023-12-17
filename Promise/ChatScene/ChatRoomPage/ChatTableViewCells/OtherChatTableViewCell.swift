import UIKit
import SnapKit
import Then

class OtherChatTableViewCell: UITableViewCell {

    let userImageView = UIImageView()
    let userNickname = UILabel()
    let userChatLabel = UILabel()
    let userChatBackgroundView = UIView()
    let userChatDateLabel = UILabel()
    
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
        
        userImageView.do{
            $0.layer.cornerRadius = 16*Constants.standardHeight
        }
        
        userNickname.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)
        }
        
        userChatLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.textColor = UIColor.white
            $0.numberOfLines = 0
        }
        
        userChatBackgroundView.do{
            $0.backgroundColor = UIColor(named: "greyOne")
            $0.layer.cornerRadius = 4*Constants.standardHeight
        }
        
        userChatDateLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)
        }
        
    }
    
    func layout(){
        userChatBackgroundView.addSubview(userChatLabel)
        
        [userImageView,userNickname,userChatBackgroundView,userChatDateLabel]
            .forEach { contentView.addSubview($0) }
        
        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalToSuperview().offset(12*Constants.standardHeight)
        }
        
        userNickname.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.top.equalToSuperview().offset(12*Constants.standardHeight)
        }
        
        userChatBackgroundView.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(250*Constants.standardWidth)
            make.leading.equalTo(userImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.top.equalTo(userNickname.snp.bottom).offset(4*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-12*Constants.standardHeight)
        }
        
        userChatLabel.snp.makeConstraints { make in
            make.leading.equalTo(12*Constants.standardWidth)
            make.trailing.equalTo(-12*Constants.standardWidth)
            make.top.equalToSuperview().offset(4*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-4*Constants.standardHeight)
        }
        
        userChatDateLabel.snp.makeConstraints { make in
            make.leading.equalTo(userChatBackgroundView.snp.trailing).offset(6*Constants.standardWidth)
            make.bottom.equalTo(userChatBackgroundView.snp.bottom)
        }
        
    }
    
    func configure(chat: ChatCell){
        userImageView.image = chat.userImage
        userNickname.text = chat.nickname
        userChatLabel.text = chat.content
        userChatDateLabel.text = String(chat.chatDate.dropFirst(5).dropLast(3))
    }
   
}
