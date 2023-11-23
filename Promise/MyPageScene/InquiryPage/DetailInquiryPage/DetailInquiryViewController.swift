import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class DetailInquiryViewController: UIViewController {
    let disposeBag = DisposeBag()
    var detailInquiryViewModel: DetailInquiryViewModel

    let titleLabel = UILabel()
    let leftButton = UIButton()
    let uploadButton = UIButton()
    let separateView = UIView()
    let inquiryTitleLabel = UILabel()
    let writerLabel = UILabel()
    let inquiryTitleTextField = UITextField()
    let inquiryContentLabel = UILabel()
    let inquiryContentTextView = UITextView()
    let replyLabel = UILabel()
    let replyTextView = UITextView()

    init(detailInquiryViewModel: DetailInquiryViewModel) {
        self.detailInquiryViewModel = detailInquiryViewModel
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
        
        detailInquiryViewModel.isMasterRelay
            .subscribe(onNext: { [weak self] isMaster in
                if(isMaster){
                    self?.replyTextView.isEditable = true
                    self?.uploadButton.isHidden = false
                }
                else{
                    self?.replyTextView.isEditable = false
                    self?.uploadButton.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        uploadButton.rx.tap
            .bind(to: detailInquiryViewModel.uploadButtonTapped)
            .disposed(by: disposeBag)

        leftButton.rx.tap
            .bind(to: detailInquiryViewModel.leftButtonTapped)
            .disposed(by: disposeBag)

        detailInquiryViewModel.titleRelay
            .bind(to:inquiryTitleTextField.rx.text)
            .disposed(by: disposeBag)

        detailInquiryViewModel.writerRelay
            .bind(to: writerLabel.rx.text)
            .disposed(by: disposeBag)
        
        detailInquiryViewModel.contentRelay
            .bind(to:inquiryContentTextView.rx.text)
            .disposed(by: disposeBag)
        
        detailInquiryViewModel.replyRelay
            .subscribe(onNext: { [weak self] reply in
                if(reply == "접수하여 답변 작성중이오니 조금만 기다려주세요 :)") {
                    self?.replyTextView.textColor = UIColor(named: "prHeavy")
                    self?.replyTextView.text = reply
                }
                else {
                    self?.replyTextView.textColor = .black
                    self?.replyTextView.text = reply
                }
            })
            .disposed(by: disposeBag)
        
    }

    private func attribute(){
        view.backgroundColor = .white

        titleLabel.do{
            $0.text = "문의내용"
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
            $0.addLeftPadding(width: 12*Constants.standardWidth)
            $0.isEnabled = false
        }
        
        writerLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
        }

        inquiryContentLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "내용"
        }

        inquiryContentTextView.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 8 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
            $0.addLeftPadding(width: 12*Constants.standardWidth)
            $0.isEditable = false
        }

        replyLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "답글"
        }
        
        replyTextView.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 8 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
            $0.addLeftPadding(width: 12*Constants.standardWidth)
            $0.isEditable = false
        }

    }

    private func layout(){
        [titleLabel,leftButton,uploadButton,separateView,inquiryTitleLabel,writerLabel,inquiryTitleTextField,inquiryContentLabel,inquiryContentTextView,replyLabel,replyTextView]
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

        writerLabel.snp.makeConstraints { make in
            make.leading.equalTo(inquiryTitleLabel.snp.trailing).offset(4*Constants.standardWidth)
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

        inquiryContentTextView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(200*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(inquiryContentLabel.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        replyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(inquiryContentTextView.snp.bottom).offset(16*Constants.standardHeight)
        }
        
        replyTextView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(200*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(replyLabel.snp.bottom).offset(4*Constants.standardHeight)
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
