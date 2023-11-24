import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class ChangeNicknameViewController: UIViewController {
    let disposeBag = DisposeBag()
    var nicknameViewModel: NicknameViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let nicknameLabel = UILabel()
    let nicknameTextField = UITextField()
    let duplicateButton = UIButton()
    let conditionImageView = UIImageView()
    let conditionLabel = UILabel()
    let secConditionImageView = UIImageView()
    let secConditionLabel = UILabel()
    let modifyButton = UIButton()
    
    init(nicknameViewModel: NicknameViewModel) {
        self.nicknameViewModel = nicknameViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        attribute()
        layout()
        bind()
    }
    
    private func bind(){
        
        leftButton.rx.tap
            .bind(to: nicknameViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text.orEmpty
            .bind(to: nicknameViewModel.nicknameTextRelay)
            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text.orEmpty
            .map{ _ in }
            .bind(to: nicknameViewModel.resetDuplicateCheckRelay)
            .disposed(by: disposeBag)
        
        nicknameViewModel.resetDuplicateCheckRelay
            .subscribe(onNext: { [weak self] in
                self?.secConditionImageView.image = UIImage(named: "redX")
                self?.secConditionImageView.tintColor = .red
                self?.secConditionLabel.textColor = .red
                self?.secConditionLabel.text = "중복확인을 눌러주세요!"
            })
            .disposed(by: disposeBag)

        
        nicknameViewModel.isValidNickname
            .drive(onNext: { [weak self] isValid in
                if(isValid){
                    self?.conditionImageView.image = UIImage(named: "blueCheck")
                    self?.conditionImageView.tintColor = .blue
                    self?.conditionLabel.textColor = .blue
                    self?.conditionLabel.text = "사용 가능한 닉네임이에요!"
                    self?.duplicateButton.alpha = 1
                    self?.duplicateButton.isEnabled = true
                }
                else{
                    self?.conditionImageView.image = UIImage(named: "redX")
                    self?.conditionImageView.tintColor = .red
                    self?.conditionLabel.textColor = .red
                    self?.conditionLabel.text = "2~10자 영문 대/소문자,한글,숫자를 사용해 주세요!"
                    self?.duplicateButton.alpha = 0.3
                    self?.duplicateButton.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        duplicateButton.rx.tap
            .bind(to: nicknameViewModel.duplicateButtonTapped)
            .disposed(by: disposeBag)
        
        nicknameViewModel.duplicateCheckResultDriver
            .drive(onNext: { [weak self] isCheck in
                if(isCheck){
                    self?.secConditionImageView.image = UIImage(named: "blueCheck")
                    self?.secConditionImageView.tintColor = .blue
                    self?.secConditionLabel.textColor = .blue
                    self?.secConditionLabel.text = "멋진 닉네임이에요:)"
                }
                else{
                    self?.secConditionImageView.image = UIImage(named: "redX")
                    self?.secConditionImageView.tintColor = .red
                    self?.secConditionLabel.textColor = .red
                    self?.secConditionLabel.text = "중복된 이름이에요!"
                }
                
            })
            .disposed(by: disposeBag)
        
        nicknameViewModel.isNextButtonEnabled
            .drive(onNext: { [weak self] isValid in
                if(isValid){
                    self?.modifyButton.isEnabled = true
                    self?.modifyButton.alpha = 1
                }
                else{
                    self?.modifyButton.isEnabled = false
                    self?.modifyButton.alpha = 0.3
                }
            })
            .disposed(by: disposeBag)
        
        modifyButton.rx.tap
            .bind(to: nicknameViewModel.modifyButtonTapped)
            .disposed(by: disposeBag)
        
        
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "닉네임 변경"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        nicknameLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "닉네임*"
            let attributedString = NSMutableAttributedString(string: text)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: "*"))
            
            $0.attributedText = attributedString
        }
        
        nicknameTextField.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.placeholder = "닉네임"
            $0.addLeftPadding(width: 12*Constants.standardWidth)
        }
        
        duplicateButton.do{
            $0.setTitle("중복확인", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
            $0.layer.cornerRadius = 8 * Constants.standardHeight
            $0.backgroundColor = UIColor(named: "greyFive")
            $0.alpha = 0.3
            $0.isEnabled = false
        }
        
        conditionImageView.do{
            $0.image = UIImage(named: "redX")
            $0.tintColor = .red
        }
        
        conditionLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.text = "2~10자 영문 대/소문자,한글,숫자를 사용해 주세요!"
            $0.textColor = .red
        }
        
        secConditionImageView.do{
            $0.image = UIImage(named: "redX")
            $0.tintColor = .red
        }
        
        secConditionLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.text = "중복확인을 눌러주세요!"
            $0.textColor = .red
        }
        
        modifyButton.do{
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.alpha = 0.3
            $0.isEnabled = false
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,nicknameLabel,nicknameTextField,duplicateButton,conditionImageView,conditionLabel,secConditionImageView,secConditionLabel,modifyButton]
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
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.width.equalTo(270*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        duplicateButton.snp.makeConstraints { make in
            make.width.equalTo(69*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalTo(nicknameTextField.snp.trailing).offset(12*Constants.standardWidth)
            make.centerY.equalTo(nicknameTextField)
        }
        
        conditionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14*Constants.standardHeight)
            make.leading.equalToSuperview().offset(16*Constants.standardWidth)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(5*Constants.standardHeight)
        }
        
        conditionLabel.snp.makeConstraints { make in
            make.leading.equalTo(conditionImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        secConditionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14*Constants.standardHeight)
            make.leading.equalToSuperview().offset(16*Constants.standardWidth)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(23*Constants.standardHeight)
        }
        
        secConditionLabel.snp.makeConstraints { make in
            make.leading.equalTo(secConditionImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.top.equalTo(nicknameTextField.snp.bottom).offset(22*Constants.standardHeight)
        }
        
        modifyButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(48*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    


}

//#if DEBUG
//import SwiftUI
//struct Preview: UIViewControllerRepresentable {
//
//    // 여기 ViewController를 변경해주세요
//    func makeUIViewController(context: Context) -> UIViewController {
//        EmailAuthViewController(emailAuthViewModel: EmailAuthViewModel())
//    }
//
//    func updateUIViewController(_ uiView: UIViewController,context: Context) {
//    }
//}
//
//struct ViewController_PreviewProvider: PreviewProvider {
//    static var previews: some View {
//        Preview()
//            .edgesIgnoringSafeArea(.all)
//            .previewDisplayName("Preview")
//            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
//
//        Preview()
//            .edgesIgnoringSafeArea(.all)
//            .previewDisplayName("Preview")
//            .previewDevice(PreviewDevice(rawValue: "iPhoneX"))
//
//    }
//}
//#endif
