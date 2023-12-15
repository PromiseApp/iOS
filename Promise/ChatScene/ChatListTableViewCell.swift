import UIKit
import SnapKit
import Then

class ChatListTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let friendCntLabel = UILabel()
    let promiseDateLabel = UILabel()
    let chatDateLabel = UILabel()
    let chatCntLabel = UILabel()
    
    var promiseID = 0
    
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
        
        titleLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
        }
        
        friendCntLabel.do{
            $0.textColor = UIColor(named: "greyFour")
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
        }
        
        promiseDateLabel.do{
            $0.textColor = UIColor(named: "greyThree")
            $0.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
        }
        
        chatDateLabel.do{
            $0.textColor = UIColor(named: "greyFour")
            $0.font = UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)
        }
        
        chatCntLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 11*Constants.standartFont)
        }
        
    }
    
    func layout(){
        [titleLabel,friendCntLabel,promiseDateLabel,chatDateLabel,chatCntLabel]
            .forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalToSuperview().offset(8*Constants.standardHeight)
        }
        
        friendCntLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4*Constants.standardWidth)
            make.top.equalToSuperview().offset(8*Constants.standardHeight)
        }
        
        promiseDateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(4*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-8*Constants.standardHeight)
        }
        
        chatDateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.top.equalToSuperview().offset(8*Constants.standardHeight)
        }
        
        chatCntLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalTo(promiseDateLabel)
        }
        
    }
    
    func configure(chatList: ChatListCell){
        promiseID = chatList.promiseID
        titleLabel.text = chatList.title
        friendCntLabel.text = "\(chatList.cnt)명"
        promiseDateLabel.text = chatList.promiseDate
    }
   
}
