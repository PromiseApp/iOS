import UIKit
import RxSwift
import SnapKit
import Then

class AnnouncementHeaderView: UITableViewHeaderFooterView {
    var disposeBag = DisposeBag()
    
    lazy var titleLabel = UILabel()
    lazy var dateLabel = UILabel()
    lazy var direButton = UIButton()
    let separateView = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func attribute(){
        titleLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
        }
        
        dateLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)
        }
        
        direButton.do{
            $0.setImage(UIImage(named: "right"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
    }
    
    func layout(){
        [titleLabel,dateLabel,separateView,direButton]
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
        
        separateView.snp.makeConstraints { make in
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.top.equalTo(dateLabel.snp.bottom).offset(7*Constants.standardHeight)
            make.bottom.equalToSuperview()
        }
        
        direButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
    }
    
    func configure(title: String, date: String, isExpanded: Bool) {
        titleLabel.text = title
        dateLabel.text = date
        direButton.setImage(UIImage(named: isExpanded ? "down" : "right"), for: .normal)
    }

}
