import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class WriteInquiryViewController: UIViewController {
    let disposeBag = DisposeBag()
    var writeInquiryViewModel: WriteInquiryViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let uploadButton = UIButton()
    let separateView = UIView()
    let inquiryTitleLabel = UILabel()
    let inquiryTitleTextField = UITextField()
    let inquiryContentLabel = UILabel()
    let inquiryContentTextView = UITextView()
    lazy var inquiryTitleLengthLabel = UILabel()
    lazy var inquiryContentLengthLabel = UILabel()
    
    init(writeInquiryViewModel: WriteInquiryViewModel) {
        self.writeInquiryViewModel = writeInquiryViewModel
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
            .bind(to: writeInquiryViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        uploadButton.rx.tap
            .bind(to: writeInquiryViewModel.uploadButtonTapped)
            .disposed(by: disposeBag)
        
        inquiryTitleTextField.rx.text.orEmpty
            .map { String($0.prefix(25)) }
            .bind(to: inquiryTitleTextField.rx.text)
            .disposed(by: disposeBag)
        
        inquiryTitleTextField.rx.text.orEmpty
            .bind(to: writeInquiryViewModel.titleRelay)
            .disposed(by: disposeBag)
        
        writeInquiryViewModel.titleLengthRelay
            .map { length -> NSAttributedString in
                let formattedString = "\(length)/25"
                let attributedString = NSMutableAttributedString(string: formattedString)
                attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: String(length).count))
                return attributedString
            }
            .asDriver(onErrorJustReturn: NSAttributedString(string: "0/25"))
            .drive(inquiryTitleLengthLabel.rx.attributedText)
            .disposed(by: disposeBag)
        
        inquiryContentTextView.rx.text.orEmpty
            .map { String($0.prefix(400)) }
            .bind(to: inquiryContentTextView.rx.text)
            .disposed(by: disposeBag)
        
        inquiryContentTextView.rx.text.orEmpty
            .bind(to: writeInquiryViewModel.contentRelay)
            .disposed(by: disposeBag)
        
        writeInquiryViewModel.contentLengthRelay
            .map { length -> NSAttributedString in
                let formattedString = "\(length)/400"
                let attributedString = NSMutableAttributedString(string: formattedString)
                attributedString.addAttribute(.foregroundColor, value: UIColor.red, range: NSRange(location: 0, length: String(length).count))
                return attributedString
            }
            .asDriver(onErrorJustReturn: NSAttributedString(string: "0/400"))
            .drive(inquiryContentLengthLabel.rx.attributedText)
            .disposed(by: disposeBag)

        
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "글쓰기"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        uploadButton.do{
            $0.setImage(UIImage(named: "upload"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        inquiryTitleLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "제목"
        }
        
        inquiryTitleTextField.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 8 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.placeholder = "제목을 입력하세요."
            $0.addLeftPadding(width: 12*Constants.standardWidth)
        }
        
        inquiryContentLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "내용"
        }
        
        inquiryContentTextView.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 8 * Constants.standardHeight
            $0.delegate = self
            $0.text = "내용을 입력하세요."
            $0.textColor = UIColor(named: "line")
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
            $0.addLeftPadding(width: 12*Constants.standardWidth)
        }
        
        [inquiryTitleLengthLabel,inquiryContentLengthLabel]
            .forEach{
                $0.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
            }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,uploadButton,separateView,inquiryTitleLabel,inquiryTitleLengthLabel,inquiryTitleTextField,inquiryContentLabel,inquiryContentLengthLabel,inquiryContentTextView]
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
        
        uploadButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        separateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        inquiryTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        inquiryTitleLengthLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalTo(inquiryTitleLabel)
        }
        
        inquiryTitleTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(inquiryTitleLabel.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        inquiryContentLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(inquiryTitleTextField.snp.bottom).offset(16*Constants.standardHeight)
        }
        
        inquiryContentLengthLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalTo(inquiryContentLabel)
        }
        
        inquiryContentTextView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(450*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(inquiryContentLabel.snp.bottom).offset(4*Constants.standardHeight)
        }
        
    }
    
    
}

extension WriteInquiryViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "line") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "내용을 입력하세요."
            textView.textColor = UIColor(named: "line")
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
