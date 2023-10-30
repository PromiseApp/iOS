import UIKit
import RxSwift
import SnapKit
import Then

class PastPromiseTableViewCell: UITableViewCell {
    let disposeBag = DisposeBag()
    
    let greyView = UIView()
    lazy var timeLabel = UILabel()
    lazy var titleLabel = UILabel()
    let locaImageView = UIImageView()
    lazy var locaLabel = UILabel()
    let skullImageView = UIImageView()
    lazy var penaltyLabel = UILabel()
    let friendImageView = UIImageView()
    lazy var friendsLabel = UILabel()
    let memoButton = UIButton()
    let memoLabel = UILabel()
    let memoView = UIView()
    
    var memoWidth: Constraint?
    var memoHeight: Constraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        memoView.layer.cornerRadius = (memoView.bounds.width + memoView.bounds.height) * 0.0278
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
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.textColor = .red
        }
        
        friendImageView.do{
            $0.image = UIImage(named: "person")
        }
        
        friendsLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
        }
        
        memoButton.do{
            $0.setTitle("메모보기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 11*Constants.standartFont)
            $0.setImage(UIImage(named: "memo"), for: .normal)
        }
        
        memoLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.layer.cornerRadius = 4*Constants.standardHeight
            $0.sizeToFit()
            
        }
        
        memoView.do{
            $0.backgroundColor = .white
            $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowRadius = 4*Constants.standardHeight
            $0.layer.shadowOffset = CGSize(width: 0, height: 4*Constants.standardHeight)
            $0.isHidden = true
        }
        
    }
    
    func layout(){
        [greyView,timeLabel,titleLabel,locaImageView,locaLabel,skullImageView,penaltyLabel,friendImageView,friendsLabel,memoButton,memoView]
            .forEach { UIView in
                contentView.addSubview(UIView)
            }
        
        memoView.addSubview(memoLabel)
        
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
        
        locaImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(9*Constants.standardHeight)
        }
        
        locaLabel.snp.makeConstraints { make in
            make.leading.equalTo(locaImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.centerY.equalTo(locaImageView)
        }
        
        skullImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(locaImageView.snp.bottom).offset(9*Constants.standardHeight)
        }
        
        penaltyLabel.snp.makeConstraints { make in
            make.leading.equalTo(skullImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.centerY.equalTo(skullImageView)
        }
        
        friendImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(skullImageView.snp.bottom).offset(8*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-12*Constants.standardHeight)
        }
        
        friendsLabel.snp.makeConstraints { make in
            make.leading.equalTo(friendImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.centerY.equalTo(friendImageView)
            make.bottom.equalToSuperview().offset(-12*Constants.standardHeight)
        }
        
        memoButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalTo(friendImageView)
            make.bottom.equalToSuperview().offset(-12*Constants.standardHeight)
        }
        
        memoView.snp.makeConstraints { make in
            make.width.equalTo(memoLabel.snp.width).offset(16 * Constants.standardWidth)
            make.height.equalTo(memoLabel.snp.height).offset(16 * Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.bottom.equalTo(memoButton.snp.top).offset(-6*Constants.standardHeight)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
    }
    
    func configure(data: PastPromiseCell){
        timeLabel.text = data.time
        titleLabel.text = data.title
        friendsLabel.text = data.friends
        locaLabel.text = data.place ?? "미정"
        penaltyLabel.text = data.penalty ?? "없음"
        var memoText = data.memo ?? "없음"
        
        if memoText.count > 20 {
            let index = memoText.index(memoText.startIndex, offsetBy: 20)
            memoText.insert("\n", at: index)
        }
        
        memoLabel.text = memoText
        memoLabel.numberOfLines = 2
        
    }
}
