import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class TokenExpirationViewController: UIViewController {
    let disposeBag = DisposeBag()
    let tokenExpirationViewModel: TokenExpirationViewModel
    
    let popupView = UIView()
    let titleLabel = UILabel()
    let descLabel = UILabel()
    let okButton = UIButton()
    
    init(tokenExpirationViewModel: TokenExpirationViewModel) {
        self.tokenExpirationViewModel = tokenExpirationViewModel
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
        
        okButton.rx.tap
            .bind(to: tokenExpirationViewModel.okButtonTapped)
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
            $0.text = "로그인 만료"
        }
        
        descLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
            $0.textAlignment = .center
            $0.numberOfLines = 2
            $0.text = "다시 로그인해 주시기 바랍니다."
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
