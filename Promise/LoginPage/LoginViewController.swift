import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class LoginViewController: UIViewController {
    let disposeBag = DisposeBag()
    var loginViewModel: LoginViewModel
    
    let idTextField = UITextField()
    let pwTextField = UITextField()
    lazy var visiblePwButton = UIButton()
    let autoLoginLabel = UILabel()
    lazy var autoLoginCheckBox = UIButton()
    let saveIdLabel = UILabel()
    lazy var saveIdCheckBox = UIButton()
    lazy var loginButton = UIButton()
    lazy var signUpButton = UIButton()
    lazy var findPwButton = UIButton()
    let separateView = UIView()
    lazy var kakaoButton = UIButton()
    lazy var appleButton = UIButton()
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
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
        autoLoginCheckBox.rx.tap
            .scan(false) { lastState, newState in !lastState }
            .bind(to: loginViewModel.firstIsChecked)
            .disposed(by: disposeBag)
        
        loginViewModel.firstIsChecked
            .subscribe(onNext: { [weak self] isChecked in
                guard let self = self else { return }
                let image = isChecked ? UIImage(systemName: "checkmark") : nil
                self.autoLoginCheckBox.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
        
        saveIdCheckBox.rx.tap
            .scan(false) { lastState, newState in !lastState }
            .bind(to: loginViewModel.secondIsChecked)
            .disposed(by: disposeBag)
        
        loginViewModel.secondIsChecked
            .subscribe(onNext: { [weak self] isChecked in
                guard let self = self else { return }
                let image = isChecked ? UIImage(systemName: "checkmark") : nil
                self.saveIdCheckBox.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
        
        visiblePwButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.pwTextField.isSecureTextEntry.toggle()
            })
            .disposed(by: disposeBag)
        
        signUpButton.rx.tap
            .subscribe(onNext: {
                let VM = EmailAuthViewModel()
                let VC = EmailAuthViewController(emailAuthViewModel: VM)
                self.show(VC, sender: nil)
            })
            .disposed(by: disposeBag)
        
        findPwButton.rx.tap
            .subscribe(onNext: {
                let VM = FindPwViewModel()
                let VC = FindPwViewController(findPwViewModel: VM)
                self.show(VC, sender: nil)
            })
            .disposed(by: disposeBag)
        
    }
    
    
    private func attribute(){
        view.backgroundColor = .white
        
        idTextField.do{
            $0.layer.borderColor = UIColor(red: 0.721, green: 0.721, blue: 0.721, alpha: 1).cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.layer.borderWidth = 1
            $0.placeholder = "이메일"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.addLeftPadding()
            $0.keyboardType = .emailAddress
        }
        
        pwTextField.do{
            $0.layer.borderColor = UIColor(red: 0.721, green: 0.721, blue: 0.721, alpha: 1).cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.layer.borderWidth = 1
            $0.placeholder = "비밀번호"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.addLeftPadding()
            $0.isSecureTextEntry = true
        }
        
        visiblePwButton.do{
            $0.setImage(UIImage(named: "visiblePw"), for: .normal)
        }
        
        autoLoginLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.text = "자동 로그인"
        }
        
        autoLoginCheckBox.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0.658, green: 0.658, blue: 0.658, alpha: 1).cgColor
            $0.tintColor = .black
        }
        
        saveIdLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.text = "아이디 저장"
        }
        
        saveIdCheckBox.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0.658, green: 0.658, blue: 0.658, alpha: 1).cgColor
            $0.tintColor = .black
        }
        
        loginButton.do{
            $0.layer.backgroundColor = UIColor(red: 0.961, green: 0.711, blue: 0.586, alpha: 1).cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.setTitle("로그인", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
        }
        
        signUpButton.do{
            $0.setTitle("회원가입", for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.setTitleColor(.black, for: .normal)
        }
        
        findPwButton.do{
            $0.setTitle("비밀번호를 잊어버리셨나요?", for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.setTitleColor(.black, for: .normal)
        }
        
        separateView.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3).cgColor
        }
        
        kakaoButton.do{
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.setTitle("카카오톡으로 시작하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.backgroundColor = UIColor(hexCode: "#FEE500")
            $0.setImage(UIImage(named: "kakao"), for: .normal)
        }
        
        appleButton.do{
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.setTitle("Apple로 시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.backgroundColor = .black
            $0.setImage(UIImage(named: "apple"), for: .normal)
        }
        
    }
    
    private func layout(){
        [idTextField,pwTextField,visiblePwButton,autoLoginLabel,autoLoginCheckBox,saveIdLabel,saveIdCheckBox,loginButton,signUpButton,findPwButton,separateView,kakaoButton,appleButton]
            .forEach{view.addSubview($0)}
        
        idTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(208*Constants.standardHeight)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(idTextField.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        visiblePwButton.snp.makeConstraints { make in
            make.width.equalTo(24*Constants.standardHeight)
            make.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalTo(pwTextField.snp.trailing).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(pwTextField)
        }
        
        autoLoginLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*Constants.standardWidth)
            make.top.equalTo(pwTextField.snp.bottom).offset(25*Constants.standardHeight)
        }
        
        autoLoginCheckBox.snp.makeConstraints { make in
            make.width.equalTo(14*Constants.standardHeight)
            make.height.equalTo(14*Constants.standardHeight)
            make.leading.equalTo(autoLoginLabel.snp.trailing).offset(4*Constants.standardWidth)
            make.centerY.equalTo(autoLoginLabel)
        }
        
        saveIdLabel.snp.makeConstraints { make in
            make.leading.equalTo(autoLoginCheckBox.snp.trailing).offset(12*Constants.standardWidth)
            make.top.equalTo(pwTextField.snp.bottom).offset(25*Constants.standardHeight)
        }
        
        saveIdCheckBox.snp.makeConstraints { make in
            make.width.equalTo(14*Constants.standardHeight)
            make.height.equalTo(14*Constants.standardHeight)
            make.leading.equalTo(saveIdLabel.snp.trailing).offset(4*Constants.standardWidth)
            make.centerY.equalTo(saveIdLabel)
        }
        
        loginButton.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(autoLoginLabel.snp.bottom).offset(16*Constants.standardHeight)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.width.equalTo(45*Constants.standardWidth)
            make.height.equalTo(16*Constants.standardHeight)
            make.leading.equalToSuperview().offset(24*Constants.standardWidth)
            make.top.equalTo(loginButton.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        findPwButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24*Constants.standardWidth)
            make.top.equalTo(loginButton.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        separateView.snp.makeConstraints { make in
            make.width.equalTo(240*Constants.standardWidth)
            make.height.equalTo(1*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(findPwButton.snp.bottom).offset(32*Constants.standardHeight)
        }
        
        kakaoButton.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom).offset(32*Constants.standardHeight)
        }
        
        kakaoButton.imageView!.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        appleButton.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(kakaoButton.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        appleButton.imageView!.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
    }

}

//#if DEBUG
//import SwiftUI
//struct Preview: UIViewControllerRepresentable {
//
//    // 여기 ViewController를 변경해주세요
//    func makeUIViewController(context: Context) -> UIViewController {
//        LoginViewController(loginViewModel: LoginViewModel())
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

