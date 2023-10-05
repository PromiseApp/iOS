import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class ConfirmEmailAuthViewController: UIViewController {
    let disposeBag = DisposeBag()
    var confirmEmailAuthViewModel:ConfirmEmailAuthViewModel
    weak var signupCoordinator: SignupCoordinator?
    weak var findPwCoordinator: FindPwCoordinator?

    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let firtLabel = UILabel()
    let secondLabel = UILabel()
    let authTextField = UITextField()
    let clearButton = UIButton()
    lazy var timerLabel = UILabel()
    let reSendButton = UIButton()
    let conditionImageView = UIImageView()
    let conditionLabel = UILabel()
    let nextButton = UIButton()
    
    init(confirmEmailAuthViewModel: ConfirmEmailAuthViewModel, signupCoordinator: SignupCoordinator?, findPwCoordinator: FindPwCoordinator?
) {
        self.signupCoordinator = signupCoordinator
        self.confirmEmailAuthViewModel = confirmEmailAuthViewModel
        self.findPwCoordinator = findPwCoordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        attribute()
        layout()
        bind()
    }
    
    private func bind(){
        
        leftButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                if let signupCoordinator = self?.signupCoordinator {
                    signupCoordinator.popToVC()
                }
                else if let findPwCoordinator = self?.findPwCoordinator {
                    findPwCoordinator.popToVC()
                }
            })
            .disposed(by: disposeBag)
                
        authTextField.rx.text.orEmpty
            .bind(to: confirmEmailAuthViewModel.authTextRelay)
            .disposed(by: disposeBag)
        
        confirmEmailAuthViewModel.isNextButtonEnabled
            .drive(nextButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .withLatestFrom(confirmEmailAuthViewModel.isAuthCodeValid)
            .subscribe(onNext: { [weak self] isValid in
                if isValid {
                    if let signupCoordinator = self?.signupCoordinator {
                        signupCoordinator.goToNicknameVC()
                    }
                    else if let findPwCoordinator = self?.findPwCoordinator {
                        findPwCoordinator.goToChangePwVC()
                    }
                }
                else {
                    self?.authTextField.text = ""
                    self?.conditionImageView.isHidden = false
                    self?.conditionLabel.textColor = .red
                    self?.conditionLabel.text = "인증번호를 다시 확인해주세요!"
                    self?.conditionLabel.isHidden = false
                    self?.conditionLabel.snp.remakeConstraints { make in
                        make.leading.equalTo(self!.conditionImageView.snp.trailing).offset(4*Constants.standardWidth)
                        make.top.equalTo(self!.authTextField.snp.bottom).offset(4*Constants.standardHeight)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        clearButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.authTextField.text = ""
            })
            .disposed(by: disposeBag)
        
        confirmEmailAuthViewModel.timerDriver
            .drive(timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        reSendButton.rx.tap
            .bind(to: confirmEmailAuthViewModel.startTimerRelay)
            .disposed(by: disposeBag)

        reSendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.nextButton.isHidden = true
                self?.authTextField.text = ""
                self?.conditionLabel.isHidden = false
                self?.conditionLabel.textColor = .black
                self?.conditionImageView.isHidden = true
                self?.conditionLabel.text = "인증번호를 다시 보내드렸어요!"
                
                self?.conditionLabel.snp.remakeConstraints{ make in
                    make.leading.equalToSuperview().offset(16*Constants.standardWidth)
                    make.top.equalTo(self!.authTextField.snp.bottom).offset(4*Constants.standardHeight)
                }
                
            })
            .disposed(by: disposeBag)
        
        
        
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
            $0.text = "인증번호"
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        firtLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 24*Constants.standartFont)
            let text = "인증이 거의 끝나가요:)"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "인증"))
            
            $0.attributedText = attributedString
        }
        
        secondLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
            $0.text = "인증번호를 입력해주세요"
        }
        
        authTextField.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.placeholder = "인증번호"
            $0.addLeftPadding()
        }
        
        clearButton.do{
            $0.setImage(UIImage(named: "clear"), for: .normal)
        }
        
        timerLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
            $0.text = "03:00"
        }
        
        reSendButton.do{
            $0.setTitle("재전송", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
            $0.layer.cornerRadius = 8 * Constants.standardHeight
            $0.backgroundColor = UIColor(named: "greyFive")
        }
        
        conditionImageView.do{
            $0.image = UIImage(named: "redX")
            $0.tintColor = .red
            $0.isHidden = true
        }
        
        conditionLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.isHidden = true
        }
        
        nextButton.do{
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.isHidden = true
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,firtLabel,secondLabel,authTextField,clearButton,timerLabel,reSendButton,conditionImageView,conditionLabel,nextButton]
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
        
        firtLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        secondLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(firtLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        authTextField.snp.makeConstraints { make in
            make.width.equalTo(270*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(secondLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(197*Constants.standardWidth)
            make.centerY.equalTo(authTextField)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.leading.equalTo(clearButton.snp.trailing).offset(4*Constants.standardWidth)
            make.centerY.equalTo(authTextField)
        }
        
        reSendButton.snp.makeConstraints { make in
            make.width.equalTo(69*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalTo(authTextField.snp.trailing).offset(12*Constants.standardWidth)
            make.centerY.equalTo(authTextField)
        }
        
        conditionImageView.snp.makeConstraints { make in
            make.width.height.equalTo(14*Constants.standardHeight)
            make.leading.equalToSuperview().offset(16*Constants.standardWidth)
            make.top.equalTo(authTextField.snp.bottom).offset(5*Constants.standardHeight)
        }
        
        conditionLabel.snp.makeConstraints { make in
            make.leading.equalTo(conditionImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.top.equalTo(authTextField.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        nextButton.snp.makeConstraints { make in
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