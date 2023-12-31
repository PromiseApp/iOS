import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class AddFriendPopupViewController: UIViewController {
    var disposeBag = DisposeBag()
    let addFriendPopupViewModel: AddFriendPopupViewModel
    
    let popupView = UIView()
    let titleLabel = UILabel()
    let textField = UITextField()
    let cancelButton = UIButton()
    let addButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        attribute()
        layout()
    }
    
    init(addFriendPopupViewModel: AddFriendPopupViewModel) {
        self.addFriendPopupViewModel = addFriendPopupViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind(){
        cancelButton.rx.tap
            .bind(to: addFriendPopupViewModel.cancelButtonTapped)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .bind(to: addFriendPopupViewModel.addButtonTapped)
            .disposed(by: disposeBag)
        
        textField.rx.text.orEmpty
            .bind(to: addFriendPopupViewModel.nicknameTextRelay)
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
        
        textField.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.placeholder = "닉네임을 입력해주세요"
            $0.addLeftPadding(width: 12*Constants.standardWidth)
            $0.backgroundColor = UIColor(named: "prLight")
        }
        
        cancelButton.do{
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor(named: "prNormal")
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
        }
        
        addButton.do{
            $0.setTitle("추가하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
        }
        
    }
    
    private func layout(){
        view.addSubview(popupView)
        
        popupView.snp.makeConstraints {
            $0.width.equalTo(260*Constants.standardWidth)
            $0.height.equalTo(158*Constants.standardHeight)
            $0.centerX.centerY.equalToSuperview()
        }
        
        [titleLabel,textField,cancelButton,addButton]
            .forEach{ popupView.addSubview($0) }
        
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(popupView.snp.top).offset(12*Constants.standardHeight)
        }
        
        textField.snp.makeConstraints {
            $0.width.equalTo(236*Constants.standardWidth)
            $0.height.equalTo(40*Constants.standardHeight)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16*Constants.standardHeight)
        }
        
        cancelButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(40*Constants.standardHeight)
            $0.leading.equalToSuperview()
            $0.bottom.equalTo(popupView.snp.bottom)
        }
        
        addButton.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.5)
            $0.height.equalTo(40*Constants.standardHeight)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(popupView.snp.bottom)
        }
    }
}
