import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class WithdrawPopupViewController: UIViewController {
    let disposeBag = DisposeBag()
    let withdrawPopupViewModel: WithdrawPopupViewModel
    
    let popupView = UIView()
    let titleLabel = UILabel()
    let descLabel = UILabel()
    let cancelButton = UIButton()
    let okButton = UIButton()
    
    init(withdrawPopupViewModel: WithdrawPopupViewModel) {
        self.withdrawPopupViewModel = withdrawPopupViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        attribute()
        layout()
    }
    
    private func bind(){
        cancelButton.rx.tap
            .bind(to: withdrawPopupViewModel.cancelButtonTapped)
            .disposed(by: disposeBag)
        
        okButton.rx.tap
            .bind(to: withdrawPopupViewModel.okButtonTapped)
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
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.textAlignment = .center
            $0.text = "앱을 떠나시는건가요?"
        }
        
        descLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.text = "떠나시면 그동안\n지켰던 약속들을 볼 수 없어요."
        }
        
        cancelButton.do{
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor(named: "prNormal")
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
        }
        
        okButton.do{
            $0.setTitle("탈퇴", for: .normal)
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
