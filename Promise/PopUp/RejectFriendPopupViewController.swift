import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class RejectFriendPopupViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let popupView = UIView()
    let titleLabel = UILabel()
    let descLabel = UILabel()
    let cancelButton = UIButton()
    let okButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        attribute()
        layout()
    }
    
    private func bind(){
        cancelButton.rx.tap
          .bind { [weak self] in
              self?.dismiss(animated: false)
          }
          .disposed(by: disposeBag)
        
        okButton.rx.tap
          .bind { [weak self] in
              self?.dismiss(animated: false)
          }
          .disposed(by: disposeBag)
    }
    
    private func attribute(){
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        popupView.do{
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 8*Constants.standardHeight
            $0.clipsToBounds = true
        }

        titleLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
            $0.textAlignment = .center
            $0.text = "친구 추가"
        }
        
        descLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.textAlignment = .center
            $0.text = "정말 거절하시겠습니까?"
        }
        
        cancelButton.do{
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor(named: "prNormal")
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
        }
        
        okButton.do{
            $0.setTitle("확인", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
        }
        
    }
    
    private func layout(){
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints {
            $0.width.equalTo(260*Constants.standardWidth)
            $0.height.equalTo(152*Constants.standardHeight)
            $0.centerX.centerY.equalToSuperview()
        }
        
        [titleLabel,descLabel,cancelButton,okButton]
            .forEach{ popupView.addSubview($0) }
        
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(popupView.snp.top).offset(12*Constants.standardHeight)
        }
        
        descLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(42*Constants.standardHeight)
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(popupView.snp.bottom)
        }
        
        okButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(42*Constants.standardHeight)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(popupView.snp.bottom)
        }
    }
}
