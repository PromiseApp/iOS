import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class TPViewController: UIViewController {
    let disposeBag = DisposeBag()
    var tPViewModel: TPViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let termButton = UIButton()
    let secondSeparateView = UIView()
    let policyButton = UIButton()
    let thirdSeparateView = UIView()
    
    init(tPViewModel: TPViewModel) {
        self.tPViewModel = tPViewModel
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
        
        leftButton.rx.tap
            .bind(to: tPViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        termButton.rx.tap
            .bind(to: tPViewModel.termButtonTapped)
            .disposed(by: disposeBag)
        
        policyButton.rx.tap
            .bind(to: tPViewModel.policyButtonTapped)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "약관 및 정책"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        [secondSeparateView,thirdSeparateView]
            .forEach{
                $0.backgroundColor = UIColor(named: "greyOne")
            }
        
        termButton.do{
            $0.setTitle("이용약관", for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
            $0.setTitleColor(.black, for: .normal)
            $0.contentHorizontalAlignment = .leading
        }
        
        policyButton.do{
            $0.setTitle("개인정보처리방침", for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
            $0.setTitleColor(.black, for: .normal)
            $0.contentHorizontalAlignment = .leading
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,termButton,secondSeparateView,policyButton,thirdSeparateView]
            .forEach{ view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(56*Constants.standardHeight)
        }
        
        leftButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        separateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        termButton.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(50*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom)
        }
        
        secondSeparateView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(termButton.snp.bottom)
        }
        
        policyButton.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(50*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(secondSeparateView.snp.bottom)
        }
        
        thirdSeparateView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(policyButton.snp.bottom)
        }
    }
}
