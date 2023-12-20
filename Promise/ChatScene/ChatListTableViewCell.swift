import UIKit
import SnapKit
import Then

class ChatListTableViewCell: UITableViewCell {

    let titleLabel = UILabel()
    let friendCntLabel = UILabel()
    let promiseDateLabel = UILabel()
    let chatDateLabel = UILabel()
    let chatCntLabel = UILabel()
    let messageTime = UILabel()
    let unReadCnt = UILabel()
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
        
        messageTime.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 12*Constants.standartFont)
        }
        
        unReadCnt.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 11*Constants.standartFont)
            $0.textColor = .white
            $0.backgroundColor = UIColor(named: "prHeavy")
            $0.layer.cornerRadius = 11*Constants.standardHeight
            $0.clipsToBounds = true
            $0.textAlignment = .center
        }
        
    }
    
    func layout(){
        [titleLabel,friendCntLabel,promiseDateLabel,chatDateLabel,chatCntLabel,messageTime,unReadCnt]
            .forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalToSuperview().offset(8*Constants.standardHeight)
        }
        
        friendCntLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(4*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
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
        
        messageTime.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.top.equalToSuperview().offset(8*Constants.standardHeight)
        }
        
        unReadCnt.snp.makeConstraints { make in
            make.width.height.equalTo(22*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.top.equalTo(messageTime.snp.bottom).offset(10*Constants.standardHeight)
        }
        
    }
    
    func configure(chatList: ChatListCell){
        promiseID = chatList.promiseID
        titleLabel.text = chatList.title
        friendCntLabel.text = "\(chatList.promiseCnt)명"
        promiseDateLabel.text = String(chatList.promiseDate.dropLast(3))
        messageTime.text = chatList.messageTime
        unReadCnt.text = String(chatList.unReadMessagesCnt)
        if(chatList.unReadMessagesCnt == 0){
            messageTime.isHidden = true
            unReadCnt.isHidden = true
        }
        else{
            messageTime.isHidden = false
            unReadCnt.isHidden = false
        }
    }
   
}
