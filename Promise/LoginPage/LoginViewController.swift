import AuthenticationServices
import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RealmSwift

class LoginViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    let disposeBag = DisposeBag()
    var loginViewModel: LoginViewModel
    
    let logoLabel = UILabel()
    let emailTextField = UITextField()
    let pwTextField = UITextField()
    let visiblePwButton = UIButton()
    let autoLoginLabel = UILabel()
    let autoLoginCheckBox = UIButton()
    let saveIdLabel = UILabel()
    let saveIdCheckBox = UIButton()
    let loginButton = UIButton()
    let signupButton = UIButton()
    let findPwButton = UIButton()
    let separateView = UIView()
    let kakaoButton = UIButton()
    let appleButton = UIButton()
    var termsTapGesture = UITapGestureRecognizer()
    var privacyPolicyTapGesture = UITapGestureRecognizer()
    let tpTextView = UITextView()
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        firstCheckboxState()
        secondCheckboxState()
        setupEmailField()
        
        bind()
        attribute()
        layout()
    }
    
    func setupEmailField() {
        let isRememberEmailEnabled = UserDefaults.standard.string(forKey: UserDefaultsKeys.isRememberEmailEnabled) ?? "N"
        if isRememberEmailEnabled == "Y", let user = fetchUserFromRealm() {
            emailTextField.text = user.account
        }
    }

    func fetchUserFromRealm() -> User? {
        let realm = try! Realm()
        return realm.objects(User.self).first
    }
    
    func firstCheckboxState() {
        let isAutoLoginEnabled = UserDefaults.standard.string(forKey: UserDefaultsKeys.isAutoLoginEnabled) ?? "N"
        let isSelected = (isAutoLoginEnabled == "Y")
        autoLoginCheckBox.isSelected = isSelected
        autoLoginCheckBox.setImage(isSelected ? UIImage(systemName: "checkmark") : nil, for: .normal)
    }
    
    func secondCheckboxState() {
        let isRememberEmailEnabled = UserDefaults.standard.string(forKey: UserDefaultsKeys.isRememberEmailEnabled) ?? "N"
        let isSelected = (isRememberEmailEnabled == "Y")
        saveIdCheckBox.isSelected = isSelected
        saveIdCheckBox.setImage(isSelected ? UIImage(systemName: "checkmark") : nil, for: .normal)
    }

    private func bind(){
        loginViewModel.emailTextRelay
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.orEmpty
            .bind(to: loginViewModel.emailTextRelay)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .bind(to: loginViewModel.passwordTextRelay)
            .disposed(by: disposeBag)
        
        autoLoginCheckBox.rx.tap
            .map { [weak self] in
                self?.autoLoginCheckBox.isSelected.toggle()
                return self?.autoLoginCheckBox.isSelected ?? false
            }
            .bind(to: loginViewModel.firstIsChecked)
            .disposed(by: disposeBag)
        
        loginViewModel.firstIsChecked
            .subscribe(onNext: { [weak self] isChecked in
                let image = isChecked ? UIImage(systemName: "checkmark") : nil
                let status = isChecked ? "Y" : "N"
                UserDefaults.standard.set(status, forKey: UserDefaultsKeys.isAutoLoginEnabled)
                self?.autoLoginCheckBox.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
        
        saveIdCheckBox.rx.tap
            .map { [weak self] in
                self?.saveIdCheckBox.isSelected.toggle()
                return self?.saveIdCheckBox.isSelected ?? false
            }
            .bind(to: loginViewModel.secondIsChecked)
            .disposed(by: disposeBag)
        
        loginViewModel.secondIsChecked
            .subscribe(onNext: { [weak self] isChecked in
                print(isChecked)
                let image = isChecked ? UIImage(systemName: "checkmark") : nil
                let status = isChecked ? "Y" : "N"
                UserDefaults.standard.set(status, forKey: UserDefaultsKeys.isRememberEmailEnabled)
                self?.saveIdCheckBox.setImage(image, for: .normal)
            })
            .disposed(by: disposeBag)
        
        visiblePwButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.pwTextField.isSecureTextEntry.toggle()
                let imageName = self?.pwTextField.isSecureTextEntry ?? true ? "invisible" : "visible"
                self?.visiblePwButton.setImage(UIImage(named: imageName), for: .normal)
                
            })
            .disposed(by: disposeBag)
        
        signupButton.rx.tap
            .bind(to: loginViewModel.signupButtonTapped)
            .disposed(by: disposeBag)
        
        findPwButton.rx.tap
            .bind(to: loginViewModel.findPwButtonTapped)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .bind(to: loginViewModel.loginButtonTapped)
            .disposed(by: disposeBag)
        
        kakaoButton.rx.tap
            .bind(to: loginViewModel.kakaoButtonTapped)
            .disposed(by: disposeBag)
        
        appleButton.rx.tap
            .subscribe(onNext: { [weak self] in
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                request.requestedScopes = [.fullName, .email]
                
                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self?.loginViewModel
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            })
            .disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        tpTextView.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .bind { [weak self] gesture in
                self?.handleTap(gesture: gesture)
            }
            .disposed(by: disposeBag)
        
    }
    
    
    private func attribute(){
        view.backgroundColor = .white
        
        logoLabel.do{
            $0.text = "PlaMeet"
            $0.font = UIFont(name: "Sriracha-Regular", size: 48*Constants.standartFont)
            $0.textColor = UIColor(named: "prHeavy")
        }
        
        emailTextField.do{
            $0.layer.borderColor = UIColor(red: 0.721, green: 0.721, blue: 0.721, alpha: 1).cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.layer.borderWidth = 1
            $0.placeholder = "이메일"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.addLeftPadding(width: 12*Constants.standardWidth)
            $0.keyboardType = .emailAddress
        }
        
        pwTextField.do{
            $0.layer.borderColor = UIColor(red: 0.721, green: 0.721, blue: 0.721, alpha: 1).cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.layer.borderWidth = 1
            $0.placeholder = "비밀번호"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.addLeftPadding(width: 12*Constants.standardWidth)
            $0.isSecureTextEntry = true
        }
        
        visiblePwButton.do{
            $0.setImage(UIImage(named: "invisible"), for: .normal)
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
        
        signupButton.do{
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
            $0.isHidden = true
        }
        
        appleButton.do{
            $0.titleLabel?.textAlignment = .center
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.setTitle("Apple로 시작하기", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.backgroundColor = .black
            $0.setImage(UIImage(named: "apple"), for: .normal)
            $0.isHidden = true
        }
        
        tpTextView.do{
            let fullText = "로그인하면 PlaMeet 이용약관 및\n 개인정보처리방침에 동의하는 것으로 간주합니다."
            let attributedString = NSMutableAttributedString(string: fullText)
            
            let plaMeetRange = (fullText as NSString).range(of: "PlaMeet")
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: plaMeetRange)
            
            let termsRange = (fullText as NSString).range(of: "이용약관")
            let privacyPolicyRange = (fullText as NSString).range(of: "개인정보처리방침")
            let underlineAttributes: [NSAttributedString.Key: Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue]
            
            attributedString.addAttributes(underlineAttributes, range: termsRange)
            attributedString.addAttributes(underlineAttributes, range: privacyPolicyRange)
            
            $0.attributedText = attributedString
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.backgroundColor = .clear
            $0.textAlignment = .center
        }
        
    }
    
    private func layout(){
        [logoLabel,emailTextField,pwTextField,visiblePwButton,autoLoginLabel,autoLoginCheckBox,saveIdLabel,saveIdCheckBox,loginButton,signupButton,findPwButton,separateView,kakaoButton,appleButton,tpTextView]
            .forEach{view.addSubview($0)}
        
        logoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(141*Constants.standardHeight)
            make.centerX.equalToSuperview()
        }
        
        emailTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(logoLabel.snp.bottom).offset(64*Constants.standardHeight)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(emailTextField.snp.bottom).offset(12*Constants.standardHeight)
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
        
        signupButton.snp.makeConstraints { make in
            make.width.equalTo(50*Constants.standardWidth)
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
        
        tpTextView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    func handleTap(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: tpTextView)
        if let textPosition = tpTextView.closestPosition(to: location),
           let textRange = tpTextView.tokenizer.rangeEnclosingPosition(textPosition, with: .word, inDirection: UITextDirection.layout(.right)),
           let tappedWord = tpTextView.text(in: textRange) {
            if tappedWord == "이용약관" {
                self.termsTapped()
            }
            else if tappedWord == "개인정보처리방침에" {
                
                self.privacyPolicyTapped()
            }
        }
    }
    
    private func termsTapped() {
        self.loginViewModel.termButtonTapped.accept(())
    }
    
    private func privacyPolicyTapped() {
        self.loginViewModel.policyButtonTapped.accept(())
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

