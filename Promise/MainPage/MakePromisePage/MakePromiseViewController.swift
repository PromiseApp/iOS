import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class MakePromiseViewController: UIViewController {
    let disposeBag = DisposeBag()
    var makePromiseViewModel:MakePromiseViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let scrollView = UIScrollView()
    let promiseTitleLabel = UILabel()
    let promiseTitleTextField = UITextField()
    let firstConditionLabel = UILabel()
    let scheduleLabel = UILabel()
    let yymmddButton = UIButton()
    let timeButton = UIButton()
    let placeLabel = UILabel()
    let placeTextField = UITextField()
    let friendLabel = UILabel()
    let addFriendButton = UIButton()
    let secAddFriendButton = UIButton()
    lazy var friendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let penaltyLabel = UILabel()
    let penaltyTextView = UITextView()
    let secondConditionLabel = UILabel()
    let memoLabel = UILabel()
    let memoTextView = UITextView()
    let thirdConditionLabel = UILabel()
    let nextButton = UIButton()
    
    init(makePromiseViewModel: MakePromiseViewModel) {
        self.makePromiseViewModel = makePromiseViewModel
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
        
//        leftButton.rx.tap
//            .subscribe(onNext: {
//                self.navigationController?.popViewController(animated: true)
//            })
//            .disposed(by: disposeBag)
//
//
//        emailTextField.rx.text.orEmpty
//            .bind(to: emailAuthViewModel.emailTextRelay)
//            .disposed(by: disposeBag)
//
//        emailAuthViewModel.validationResultDriver
//            .drive(onNext: { [weak self] isValid in
//                guard let self = self else { return }
//                if(isValid){
//                    self.nextButton.isHidden = false
//                }
//                else{
//                    self.nextButton.isHidden = true
//                }
//            })
//            .disposed(by: disposeBag)
//
//        nextButton.rx.tap
//            .bind(to: emailAuthViewModel.nextButtonTapped)
//            .disposed(by: disposeBag)
//
//        emailAuthViewModel.serverValidationResult
//            .drive(onNext: {[weak self] isValid in
//                if(isValid){
//                    let VM = ConfirmEmailAuthViewModel()
//                    let VC = ConfirmEmailAuthViewController(confirmEmailAuthViewModel: VM)
//                    VC.titleLabel.text = self?.titleLabel.text
//                    self?.show(VC, sender: nil)
//                }
//                if !isValid {
//                    let popupViewController = PopUpViewController(title: "입력오류", desc: "입력한 정보를 다시 확인해주세요!")
//                    popupViewController.modalPresentationStyle = .overFullScreen
//                    self?.present(popupViewController, animated: false)
//                }
//
//            })
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "약속 만들기"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        promiseTitleLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "제목*"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "*"))
            
            $0.attributedText = attributedString
        }
        
        promiseTitleTextField.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.placeholder = "지인들과 술자리 / 수영장 가기 등"
            $0.addLeftPadding()
        }
        
        firstConditionLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 13)
            let text = "20자까지 입력 가능해요!"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "20자"))
            
            $0.attributedText = attributedString
        }
        
        scheduleLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "일정*"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "*"))
            
            $0.attributedText = attributedString
        }
        
        yymmddButton.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.setTitle("YY/MM/DD", for: .normal)
            $0.setTitleColor(UIColor(named: "greyOne"), for: .normal)
        }
        
        timeButton.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.setTitle("00:00", for: .normal)
            $0.setTitleColor(UIColor(named: "greyOne"), for: .normal)
        }
        
        placeLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "장소"
        }
        
        placeTextField.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.placeholder = "장소를 입력해보세요"
            $0.addLeftPadding()
        }
        
        friendLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "친구"
        }
        
        addFriendButton.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.setImage(UIImage(named: "plus"), for: .normal)
        }
        
        secAddFriendButton.do{
            $0.setTitle("추가하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setImage(UIImage(named: "right"), for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 15*Constants.standartFont)
        }
        
//        friendCollectionView.do{
//
//        }
        
        penaltyLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "벌칙"
        }
        
        penaltyTextView.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.delegate = self
            $0.text = "벌칙을 정해보세요"
            $0.textColor = UIColor(named: "line")
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.addLeftPadding()
        }
        
        secondConditionLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "약속을 지킬 수 있도록 재밌는 벌칙을 정해보세요!"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "재밌는 벌칙"))
            
            $0.attributedText = attributedString
        }
        
        memoLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "메모"
        }
        
        memoTextView.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.delegate = self
            $0.text = "중요한 내용을 메모해두세요"
            $0.textColor = UIColor(named: "line")
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.addLeftPadding()
        }
        
        thirdConditionLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "준비물, 계획 등 중요한 내용을 메모해두세요"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "메모"))
            
            $0.attributedText = attributedString
        }
        
        nextButton.do{
            $0.setTitle("만들기", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.alpha = 0.3
            $0.isEnabled = false
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,scrollView,nextButton]
            .forEach{ view.addSubview($0) }
        
        [promiseTitleLabel,promiseTitleTextField,firstConditionLabel,scheduleLabel,yymmddButton,timeButton,placeLabel,placeTextField,friendLabel,addFriendButton,secAddFriendButton,friendCollectionView,penaltyLabel,penaltyTextView,secondConditionLabel,memoLabel,memoTextView,thirdConditionLabel]
            .forEach{ scrollView.addSubview($0) }
        
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
        
        nextButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(48*Constants.standardWidth)
            make.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
            make.top.equalTo(separateView.snp.bottom)
        }
        
        promiseTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalToSuperview().offset(24*Constants.standardHeight)
        }
        
        promiseTitleTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(promiseTitleLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        firstConditionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(promiseTitleTextField.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        scheduleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(firstConditionLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        yymmddButton.snp.makeConstraints { make in
            make.width.equalTo(173.5*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(scheduleLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        timeButton.snp.makeConstraints { make in
            make.width.equalTo(173.5*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalTo(yymmddButton.snp.trailing).offset(4*Constants.standardWidth)
            make.top.equalTo(scheduleLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(timeButton.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        placeTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(placeLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        friendLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(placeTextField.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        addFriendButton.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(friendLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        addFriendButton.imageView!.snp.makeConstraints { make in
            make.width.height.equalTo(32*Constants.standardHeight)
        }
        
        secAddFriendButton.snp.makeConstraints { make in
            make.width.equalTo(85*Constants.standardWidth)
            make.height.equalTo(18*Constants.standardHeight)
            make.trailing.equalTo(view.snp.trailing).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(friendLabel)
        }
        
        
        penaltyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(addFriendButton.snp.bottom).offset(21*Constants.standardHeight)
        }
        
        penaltyTextView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(100*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(penaltyLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        secondConditionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(penaltyTextView.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(secondConditionLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(100*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(memoLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        thirdConditionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(memoTextView.snp.bottom).offset(4*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-50*Constants.standardHeight)
        }
        
        
    }
    
}

extension MakePromiseViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "line") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == penaltyTextView {
                textView.text = "벌칙을 정해보세요"
            } else if textView == memoTextView {
                textView.text = "중요한 내용을 메모해두세요"
            }
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
