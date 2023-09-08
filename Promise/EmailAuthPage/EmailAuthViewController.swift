import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class EmailAuthViewController: UIViewController {
    let disposeBag = DisposeBag()
    var emailAuthViewModel:EmailAuthViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let firtLabel = UILabel()
    let secondLabel = UILabel()
    let emailTextField = UITextField()
    let nextButton = UIButton()
    
    init(emailAuthViewModel: EmailAuthViewModel) {
        self.emailAuthViewModel = emailAuthViewModel
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
        
        emailTextField.rx.text.orEmpty
            .bind(to: emailAuthViewModel.emailTextRelay)
            .disposed(by: disposeBag)
        
        emailAuthViewModel.validationResultSignal
            .emit(onNext: { [weak self] isValid in
                guard let self = self else { return }
                if(isValid){
                    self.nextButton.isHidden = false
                }
                else{
                    self.nextButton.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: {
                let VM = ConfirmEmailAuthViewModel()
                let VC = ConfirmEmailAuthViewController(confirmEmailAuthViewModel: VM)
                self.show(VC, sender: nil)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "본인인증"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        firtLabel.do{
            $0.numberOfLines = 2
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 24*Constants.standartFont)
            let text = "안녕하세요! 본인 확인을 위해\n인증을 완료해주세요:)"
            let attributedString = NSMutableAttributedString(string: text)
            
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "본인 확인"))
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "인증"))
            
            $0.attributedText = attributedString
        }
        
        secondLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
            $0.text = "이메일을 입력해주세요"
        }
        
        emailTextField.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.placeholder = "abcde@example.com"
            $0.addLeftPadding()
        }
        
        nextButton.do{
            $0.setTitle("인증번호 요청", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.isHidden = true
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,firtLabel,secondLabel,emailTextField,nextButton]
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
        
        emailTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(secondLabel.snp.bottom).offset(12*Constants.standardHeight)
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
