import UIKit
import PhotosUI
import Photos
import RxSwift
import RxCocoa
import Then
import SnapKit

class SignupViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var signupViewModel: SignupViewModel
    let limitedViewModel: LimitedViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let profileLabel = UILabel()
    let secondProfileLabel = UILabel()
    lazy var userProfileButton = UIButton()
    let cameraButton = UIButton()
    let emailLabel = UILabel()
    let emailTextField = UITextField()
    let pwLabel = UILabel()
    let pwTextField = UITextField()
    let rePwLabel = UILabel()
    let rePwTextField = UITextField()
    let firstClearButton = UIButton()
    let secClearButton = UIButton()
    let firstVisibleButton = UIButton()
    let secVisibleButton = UIButton()
    let conditionImageView = UIImageView()
    let conditionLabel = UILabel()
    let secConditionImageView = UIImageView()
    let secConditionLabel = UILabel()
    let nextButton = UIButton()
    
    init(signupViewModel: SignupViewModel, limitedViewModel: LimitedViewModel) {
        self.signupViewModel = signupViewModel
        self.limitedViewModel = limitedViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
        bind()
    }
    
    private func bind(){
        
        leftButton.rx.tap
            .bind(to: signupViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        signupViewModel.selectedImage
            .bind(to: userProfileButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        limitedViewModel.selectedPhoto
            .bind(to: userProfileButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        userProfileButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.checkPhotoLibraryPermission()
            })
            .disposed(by: disposeBag)
        
        cameraButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.checkPhotoLibraryPermission()
            })
            .disposed(by: disposeBag)
        
        signupViewModel.emailTextRelay
            .bind(to: emailTextField.rx.text)
            .disposed(by: disposeBag)
        
        pwTextField.rx.text.orEmpty
            .bind(to: signupViewModel.pwTextRelay)
            .disposed(by: disposeBag)
        
        rePwTextField.rx.text.orEmpty
            .bind(to: signupViewModel.rePwTextRelay)
            .disposed(by: disposeBag)
            
        firstClearButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.pwTextField.text = ""
            })
            .disposed(by: disposeBag)
        
        secClearButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.rePwTextField.text = ""
            })
            .disposed(by: disposeBag)
        
        firstVisibleButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.pwTextField.isSecureTextEntry.toggle()
                if ((self?.pwTextField.isSecureTextEntry) != nil) {
                    self?.firstVisibleButton.setImage(UIImage(named: "invisible"), for: .normal)
                } else {
                    self?.firstVisibleButton.setImage(UIImage(named: "visible"), for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        secVisibleButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.rePwTextField.isSecureTextEntry.toggle()
                if ((self?.rePwTextField.isSecureTextEntry) != nil) {
                    self?.secVisibleButton.setImage(UIImage(named: "invisible"), for: .normal)
                } else {
                    self?.secVisibleButton.setImage(UIImage(named: "visible"), for: .normal)
                }
            })
            .disposed(by: disposeBag)
        
        signupViewModel.isPasswordValid
            .drive(onNext: { [weak self] isValid in
                if(isValid){
                    self?.pwTextField.layer.borderColor = UIColor.blue.cgColor
                    self?.conditionImageView.image = UIImage(named: "blueCheck")
                    self?.conditionImageView.tintColor = .blue
                    self?.conditionLabel.textColor = .blue
                    self?.conditionLabel.text = "사용 가능한 비밀번호에요!"
                }
                else{
                    self?.pwTextField.layer.borderColor = UIColor.red.cgColor
                    self?.conditionImageView.image = UIImage(named: "redX")
                    self?.conditionImageView.tintColor = .red
                    self?.conditionLabel.textColor = .red
                    self?.conditionLabel.text = "8~16자 영문 대/소문자,숫자,특수문자를 모두 사용해 주세요!"
                }
            })
            .disposed(by: disposeBag)
        
        signupViewModel.isPasswordMatching
            .drive(onNext: { [weak self] isMatching in
                if(isMatching){
                    self?.rePwTextField.layer.borderColor = UIColor.blue.cgColor
                    self?.secConditionImageView.image = UIImage(named: "blueCheck")
                    self?.secConditionImageView.tintColor = .blue
                    self?.secConditionLabel.textColor = .blue
                    self?.secConditionLabel.text = "비밀번호가 일치해요!"
                }
                else{
                    self?.rePwTextField.layer.borderColor = UIColor.red.cgColor
                    self?.secConditionImageView.image = UIImage(named: "redX")
                    self?.secConditionImageView.tintColor = .red
                    self?.secConditionLabel.textColor = .red
                    self?.secConditionLabel.text = "비밀번호가 일치하지 않아요!"
                }
            })
            .disposed(by: disposeBag)
        
        signupViewModel.isNextButtonEnabled
            .drive(onNext: { [weak self] isValid in
                if(isValid){
                    self?.nextButton.isEnabled = true
                    self?.nextButton.alpha = 1
                }
                else{
                    self?.nextButton.isEnabled = false
                    self?.nextButton.alpha = 0.3
                }
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(to: signupViewModel.nextButtonTapped)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "회원가입"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        profileLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "프로필 등록"
        }
        
        secondProfileLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "프로필을 선택해주세요"
        }
        
        userProfileButton.do{
            $0.layer.cornerRadius = 96*Constants.standardHeight / 2
            $0.sizeToFit()
            $0.clipsToBounds = true
            $0.setImage(UIImage(named: "user"), for: .normal)
        }
        
        cameraButton.do{
            $0.sizeToFit()
            $0.clipsToBounds = true
            $0.setImage(UIImage(named: "camera"), for: .normal)
        }
        
        emailLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "이메일"
        }
        
        emailTextField.do{
            $0.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.textColor = UIColor(named: "greyOne")
            $0.placeholder = "이메일"
            $0.addLeftPadding(width: 12*Constants.standardWidth)
        }
        
        pwLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "비밀번호*"
            let attributedString = NSMutableAttributedString(string: text)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: "*"))
            $0.attributedText = attributedString
        }
        
        pwTextField.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.placeholder = "비밀번호"
            $0.isSecureTextEntry = false
            $0.addLeftPadding(width: 12*Constants.standardWidth)
        }
        
        rePwLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "비밀번호 확인*"
            let attributedString = NSMutableAttributedString(string: text)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: "*"))
            
            $0.attributedText = attributedString
        }
        
        rePwTextField.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.placeholder = "비밀번호 확인"
            $0.isSecureTextEntry = true
            $0.textContentType = .oneTimeCode
            $0.addLeftPadding(width: 12*Constants.standardWidth)
        }
        
        [firstClearButton,secClearButton]
            .forEach{ $0.setImage(UIImage(named: "clear"), for: .normal) }
        
        firstVisibleButton.do{
            $0.setImage(UIImage(named: "visible"), for: .normal)
        }
        
        secVisibleButton.do{
            $0.setImage(UIImage(named: "invisible"), for: .normal)
        }
        
        conditionImageView.do{
            $0.image = UIImage(named: "redX")
            $0.tintColor = .red
        }
        
        conditionLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.text = "8~16자 영문 대/소문자,숫자,특수문자를 모두 사용해 주세요!"
            $0.textColor = .red
        }
        
        secConditionImageView.do{
            $0.image = UIImage(named: "redX")
            $0.tintColor = .red
        }
        
        secConditionLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.text = "비밀번호가 일치하지 않아요!"
            $0.textColor = .red
        }
        
        nextButton.do{
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.alpha = 0.3
            $0.isEnabled = false
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,profileLabel,userProfileButton,cameraButton,secondProfileLabel,emailLabel,emailTextField,pwLabel,pwTextField,firstClearButton,firstVisibleButton,conditionImageView,conditionLabel,rePwLabel,rePwTextField,secClearButton,secVisibleButton,secConditionImageView,secConditionLabel,nextButton]
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
        
        profileLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        userProfileButton.snp.makeConstraints { make in
            make.width.height.equalTo(96*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(profileLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalTo(userProfileButton.snp.leading).offset(72*Constants.standardWidth)
            make.top.equalTo(userProfileButton.snp.top).offset(72*Constants.standardHeight)
        }
        
        secondProfileLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(cameraButton.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(secondProfileLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(emailLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        pwLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(emailTextField.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        pwTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(pwLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        firstClearButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalTo(pwTextField.snp.trailing).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(pwTextField)
        }
        
        firstVisibleButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalTo(firstClearButton.snp.leading).offset(-4*Constants.standardWidth)
            make.centerY.equalTo(pwTextField)
        }
        
        conditionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14*Constants.standardHeight)
            make.leading.equalToSuperview().offset(16*Constants.standardWidth)
            make.top.equalTo(pwTextField.snp.bottom).offset(5*Constants.standardHeight)
        }
        
        conditionLabel.snp.makeConstraints { make in
            make.leading.equalTo(conditionImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.top.equalTo(pwTextField.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        rePwLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(pwTextField.snp.bottom).offset(32*Constants.standardHeight)
        }
        
        rePwTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(rePwLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        secClearButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalTo(rePwTextField.snp.trailing).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(rePwTextField)
        }
        
        secVisibleButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalTo(secClearButton.snp.leading).offset(-4*Constants.standardWidth)
            make.centerY.equalTo(rePwTextField)
        }
        
        secConditionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14*Constants.standardHeight)
            make.leading.equalToSuperview().offset(16*Constants.standardWidth)
            make.top.equalTo(rePwTextField.snp.bottom).offset(5*Constants.standardHeight)
        }
        
        secConditionLabel.snp.makeConstraints { make in
            make.leading.equalTo(secConditionImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.top.equalTo(rePwTextField.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(48*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    private func checkPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        case .limited:
            self.signupViewModel.goToLimitedCollectionView.accept(())
        default:
            // 권한 요청 또는 다른 처리
            break
        }
    }

}

extension SignupViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.signupViewModel.selectedImage.accept(image)
                }
            }
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
