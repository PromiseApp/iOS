import UIKit
import SnapKit
import Then

class PromiseTableViewCell: UITableViewCell {

    let greyView = UIView()
    lazy var timeLabel = UILabel()
    lazy var titleLabel = UILabel()
    let separateLabel = UILabel()
    lazy var cntLabel = UILabel()
    let locaImageView = UIImageView()
    lazy var locaLabel = UILabel()
    let skullImageView = UIImageView()
    lazy var penaltyLabel = UILabel()
    let pencilImageView = UIImageView()
    
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
        
        greyView.do{
            $0.backgroundColor = UIColor(named: "greyThree")
        }
        
        timeLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
        }
        
        timeLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 18*Constants.standartFont)
        }
        
        separateLabel.do{
            $0.text = "|"
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
        }
        
        cntLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
        }
        
        pencilImageView.do{
            $0.image = UIImage(named: "pencil")
        }
        
        locaImageView.do{
            $0.image = UIImage(named: "loca")
        }
        
        locaLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
        }
        
        skullImageView.do{
            $0.image = UIImage(named: "skull")
        }
        
        penaltyLabel.do{
            $0.font = UIFont(name: "Pretendard-Bold", size: 13*Constants.standartFont)
            $0.textColor = .red
        }
        
    }
    
    func layout(){
        [greyView,timeLabel,titleLabel,separateLabel,cntLabel,locaImageView,locaLabel,skullImageView,penaltyLabel,pencilImageView]
            .forEach { UIView in
                contentView.addSubview(UIView)
            }

        greyView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.centerY.equalTo(greyView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(greyView.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        separateLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        cntLabel.snp.makeConstraints { make in
            make.leading.equalTo(separateLabel.snp.trailing).offset(8*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        locaImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(5*Constants.standardHeight)
        }
        
        locaLabel.snp.makeConstraints { make in
            make.leading.equalTo(locaImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.centerY.equalTo(locaImageView)
        }
        
        skullImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(locaImageView.snp.bottom).offset(9*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-12*Constants.standardHeight)
        }
        
        penaltyLabel.snp.makeConstraints { make in
            make.leading.equalTo(skullImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.centerY.equalTo(skullImageView)
            make.bottom.equalToSuperview().offset(-12*Constants.standardHeight)
        }
        
        pencilImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-16*Constants.standardWidth)
            make.bottom.equalToSuperview().offset(-32*Constants.standardHeight)
        }
        
    }
    
    func configure(data: PromiseCell){
        timeLabel.text = data.time
        titleLabel.text = data.title
        cntLabel.text = "\(data.cnt)명"
        locaLabel.text = data.place ?? "미정"
        penaltyLabel.text = data.penalty ?? "미정"
    }
   
}
