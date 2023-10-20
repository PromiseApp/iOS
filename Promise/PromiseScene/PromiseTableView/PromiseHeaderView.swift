import UIKit
import RxSwift
import SnapKit
import Then

class PromiseHeaderView: UITableViewHeaderFooterView {
    var disposeBag = DisposeBag()
    
    lazy var dateLabel = UILabel()
    lazy var direButton = UIButton()
    let separatorView = UIView()
    
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
        var backgroundConfig = UIBackgroundConfiguration.listPlainHeaderFooter()
        backgroundConfig.backgroundColor = UIColor(named: "prNormal")
        backgroundConfiguration = backgroundConfig
        
        dateLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
        }
        
        direButton.do{
            $0.setImage(UIImage(named: "right"), for: .normal)
        }
        
        separatorView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
    }
    
    func layout(){
        [dateLabel,direButton,separatorView]
            .forEach { UIView in
                contentView.addSubview(UIView)
            }
 
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalToSuperview().offset(8*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-8*Constants.standardHeight)
        }
        
        direButton.snp.makeConstraints { make in
            make.width.height.equalTo(20*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-16*Constants.standardWidth)
            make.centerY.equalTo(dateLabel)
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
        }
        
    }
    
    func configure(date: String, isExpanded: Bool) {
        dateLabel.text = date
        direButton.setImage(UIImage(named: isExpanded ? "down" : "right"), for: .normal)
    }

}
