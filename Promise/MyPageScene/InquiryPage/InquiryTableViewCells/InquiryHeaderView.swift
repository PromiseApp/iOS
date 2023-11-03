import UIKit
import SnapKit
import Then

class InquiryHeaderView: UITableViewHeaderFooterView {
    
    lazy var titleLabel = UILabel()
    lazy var dateLabel = UILabel()
    lazy var stateLabel = UILabel()
    let separateView = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute(){
        titleLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
        }
        
        dateLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)
        }
        
        stateLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
    }
    
    func layout(){
        [titleLabel,dateLabel,stateLabel,separateView]
            .forEach { UIView in
                contentView.addSubview(UIView)
            }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalToSuperview().offset(8*Constants.standardHeight)
        }
 
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(titleLabel.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        stateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        separateView.snp.makeConstraints { make in
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.top.equalTo(dateLabel.snp.bottom).offset(7*Constants.standardHeight)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func configure(title: String, date: String, state: Bool) {
        titleLabel.text = title
        dateLabel.text = date
        stateLabel.text = state ? "답변완료" : "접수"
    }

}
