import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class FindPwViewController: UIViewController {
    let disposeBag = DisposeBag()
    var findPwViewModel:FindPwViewModel
    weak var findPwCoordinator: FindPwCoordinator?
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let emailLabel = UILabel()
    let emailTextField = UITextField()
    let clearButton = UIButton()
    let nextButton = UIButton()
    
    init(findPwViewModel: FindPwViewModel, findPwCoordinator: FindPwCoordinator) {
        self.findPwViewModel = findPwViewModel
        self.findPwCoordinator = findPwCoordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        bind()
        attribute()
        layout()
    }
    
    private func bind(){
        
        leftButton.rx.tap
            .subscribe(onNext: {[weak self] _ in
                self?.findPwCoordinator?.popToVC()
            })
            .disposed(by: disposeBag)
        
        
        emailTextField.rx.text.orEmpty
            .bind(to: findPwViewModel.emailTextRelay)
            .disposed(by: disposeBag)
        
        findPwViewModel.validationResultDriver
            .drive(onNext: { [weak self] isValid in
                guard let self = self else { return }
                if(isValid){
                    self.nextButton.isEnabled = true
                    self.nextButton.alpha = 1
                }
                else{
                    self.nextButton.isEnabled = false
                    self.nextButton.alpha = 0.3
                }
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(to: findPwViewModel.nextButtonTapped)
            .disposed(by: disposeBag)
        
        findPwViewModel.serverValidationResult
            .drive(onNext: {[weak self] isValid in
                if(isValid){
                    self?.findPwCoordinator?.goToConfirmEmailAuthVC()
                }
                if !isValid {
                    let popupViewController = PopUpViewController(title: "입력오류", desc: "입력한 정보를 다시 확인해주세요!")
                    popupViewController.modalPresentationStyle = .overFullScreen
                    self?.present(popupViewController, animated: false)
                }
                
            })
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "비밀번호 찾기"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        emailLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "이메일*"
            let attributedString = NSMutableAttributedString(string: text)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: (text as NSString).range(of: "*"))
            
            $0.attributedText = attributedString
        }
        
        emailTextField.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.placeholder = "abcde@example.com"
            $0.addLeftPadding(width: 12*Constants.standardWidth)
        }
        
        clearButton.do{
            $0.setImage(UIImage(named: "clear"), for: .normal)
        }
        
        nextButton.do{
            $0.setTitle("인증번호 요청", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.isEnabled = false
            $0.alpha = 0.3
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,emailLabel,emailTextField,clearButton,nextButton]
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
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(emailLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        clearButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalTo(emailTextField.snp.trailing).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(emailTextField)
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(48*Constants.standardWidth)
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
