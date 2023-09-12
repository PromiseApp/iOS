import UIKit
import SnapKit
import Then

class MyPopupView: UIView {
    
    let popupView = UIView()

    let titleLabel = UILabel()
    let descLabel = UILabel()
    
    let okButton = UIButton()
    
    
    init(title: String, desc: String) {
        self.titleLabel.text = title
        self.descLabel.text = desc
        
        super.init(frame: .zero)
        
        self.backgroundColor = .black.withAlphaComponent(0.3)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func attribute(){
        popupView.do{
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8*Constants.standardHeight
            $0.clipsToBounds = true
        }

        titleLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
            $0.textAlignment = .center
        }
        descLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.textAlignment = .center
        }
        
        okButton.do{
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor(named: "prStrong")
        }
        
    }
    
    private func layout(){
        self.addSubview(popupView)
        
        popupView.snp.makeConstraints {
            $0.width.equalTo(260*Constants.standardWidth)
            $0.height.equalTo(152*Constants.standardHeight)
            $0.centerX.centerY.equalToSuperview()
        }
        
        [titleLabel,descLabel,okButton]
            .forEach{ popupView.addSubview($0) }
        
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(popupView.snp.top).offset(12*Constants.standardHeight)
        }
        
        descLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        okButton.snp.makeConstraints {
            $0.width.equalTo(260*Constants.standardWidth)
            $0.height.equalTo(42*Constants.standardHeight)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(popupView.snp.bottom)
        }
    }
    
}

