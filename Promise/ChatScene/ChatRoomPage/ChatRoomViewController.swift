import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit

class ChatRoomViewController: UIViewController {
    let disposeBag = DisposeBag()
    var chatRoomViewModel: ChatRoomViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let menuButton = UIButton()
    let separateView = UIView()
    let chatTableView = UITableView()
    let stackView = UIView()
    let chatTextView = UITextView()
    let sendButton = UIButton()
    let participantView: ParticipantView
    
    var textViewHeightConstraint: Constraint?
    var stackViewHeightConstraint: Constraint?
    
    let participantViewSwipeGesture = UISwipeGestureRecognizer()
    let backgroundViewTapGesture = UITapGestureRecognizer()
    let backgroundView = UIView()
   
    init(chatRoomViewModel: ChatRoomViewModel, participantView: ParticipantView) {
        self.chatRoomViewModel = chatRoomViewModel
        self.participantView = participantView
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chatTextView.rx.text
            .subscribe(onNext: { [weak self] text in
                self?.chatRoomViewModel.chatTextFieldRelay.accept(text)
                self?.adjustTextViewHeight()
            })
            .disposed(by: disposeBag)
    }
    
    private func bind(){

        chatRoomViewModel.chatTextFieldRelay
            .bind(to: chatTextView.rx.text)
            .disposed(by: disposeBag)
        
        leftButton.rx.tap
            .bind(to: chatRoomViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        menuButton.rx.tap
            .bind(onNext: { [weak self] _ in
                self?.updateParticipantViewConstraints()
            })
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .bind(to: chatRoomViewModel.sendButtonTapped)
            .disposed(by: disposeBag)
        
        sendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.scrollTableViewToBottom()
            })
            .disposed(by: disposeBag)
        
        chatRoomViewModel.chatDriver
            .drive(chatTableView.rx.items) { [weak self] _ , index, chat in
                if chat.nickname == self?.chatRoomViewModel.userNickname {
                    let cell = self?.chatTableView.dequeueReusableCell(withIdentifier: "MyChatTableViewCell", for: IndexPath(row: index, section: 0)) as! MyChatTableViewCell
                    cell.configure(chat: chat)
                    return cell
                } else {
                    let cell = self?.chatTableView.dequeueReusableCell(withIdentifier: "OtherChatTableViewCell", for: IndexPath(row: index, section: 0)) as! OtherChatTableViewCell
                    cell.configure(chat: chat)
                    return cell
                }
            }
            .disposed(by: disposeBag)
        
        participantViewSwipeGesture.rx.event
            .bind(onNext: { [weak self] _ in
                self?.chatRoomViewModel.isParticipantViewVisible.accept(false)
            })
            .disposed(by: disposeBag)
        
        backgroundViewTapGesture.rx.event
            .bind(onNext: { [weak self] _ in
                self?.chatRoomViewModel.isParticipantViewVisible.accept(false)
            })
            .disposed(by: disposeBag)
        
        chatRoomViewModel.isParticipantViewVisible
            .subscribe(onNext: { [weak self] isVisible in
                self?.toggleParticipantView(isVisible: isVisible)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "채팅방"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        menuButton.do{
            $0.setImage(UIImage(named: "menu"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        chatTableView.do{
            $0.separatorStyle = .none
            $0.register(MyChatTableViewCell.self, forCellReuseIdentifier: "MyChatTableViewCell")
            $0.register(OtherChatTableViewCell.self, forCellReuseIdentifier: "OtherChatTableViewCell")
        }
        
        chatTextView.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prLight")
            $0.addLeftPadding(width: 12*Constants.standardWidth)
            $0.layer.cornerRadius = 16*Constants.standardHeight
            $0.isScrollEnabled = false
        }
        
        sendButton.do{
            $0.backgroundColor = UIColor(named: "prHeavy")
            $0.setImage(UIImage(named: "send"), for: .normal)
            $0.layer.cornerRadius = 16*Constants.standardHeight
        }
        
        participantView.do{
            $0.addGestureRecognizer(participantViewSwipeGesture)
        }
        
        participantViewSwipeGesture.do{
            $0.direction = .right
        }
        
        backgroundView.do{
            $0.backgroundColor = UIColor.black
            $0.alpha = 0
            $0.isHidden = true
            $0.addGestureRecognizer(backgroundViewTapGesture)
        }
        
    }
    
    private func layout(){
        [chatTextView,sendButton]
            .forEach { stackView.addSubview($0) }
        
        [titleLabel,leftButton,menuButton,separateView,stackView,chatTableView,participantView]
            .forEach{ view.addSubview($0) }
        
        view.insertSubview(backgroundView, belowSubview: participantView)
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(56*Constants.standardHeight)
        }
        
        leftButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        menuButton.snp.makeConstraints { make in
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
        
        chatTextView.snp.makeConstraints { make in
            make.width.equalTo(310*Constants.standardWidth)
            textViewHeightConstraint = make.height.equalTo(32*Constants.standardHeight).constraint
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.width.height.equalTo(32*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            stackViewHeightConstraint = make.height.equalTo(48*Constants.standardHeight).constraint
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        chatTableView.snp.makeConstraints { make in
            make.top.equalTo(separateView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top)
        }
        
        participantView.snp.makeConstraints { make in
            make.width.equalTo(300*Constants.standardWidth)
            make.leading.equalTo(view.snp.trailing)
            make.top.equalTo(50*Constants.standardHeight)
            make.bottom.equalToSuperview()
        }
        
    }
    
    func adjustTextViewHeight() {
        let fixedWidth = chatTextView.frame.size.width
        let newSize = chatTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if newSize.height >= 100.0 {
            chatTextView.isScrollEnabled = true
            textViewHeightConstraint?.update(offset: 96*Constants.standardHeight)
            stackViewHeightConstraint?.update(offset: 112*Constants.standardHeight)
        } else {
            chatTextView.isScrollEnabled = false
            textViewHeightConstraint?.update(offset: newSize.height*Constants.standardHeight)
            stackViewHeightConstraint?.update(offset: (newSize.height + 16)*Constants.standardHeight)
        }

        chatTableView.snp.updateConstraints { make in
            make.bottom.equalTo(stackView.snp.top)
        }
        
        view.layoutIfNeeded()
    }
    
    func scrollTableViewToBottom() {
        let numberOfSections = chatTableView.numberOfSections
        let numberOfRows = chatTableView.numberOfRows(inSection: numberOfSections - 1)
        
        if numberOfRows > 0 {
            let indexPath = IndexPath(row: numberOfRows - 1, section: numberOfSections - 1)
            chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    func updateParticipantViewConstraints() {
        participantView.snp.remakeConstraints { make in
            make.width.equalTo(300*Constants.standardWidth)
            make.trailing.equalToSuperview()
            make.top.equalTo(50*Constants.standardHeight)
            make.bottom.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowAnimatedContent){
            
            self.backgroundView.alpha = 0.3
            self.backgroundView.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    func toggleParticipantView(isVisible: Bool) {
        participantView.snp.remakeConstraints { make in
            make.width.equalTo(300*Constants.standardWidth)
            isVisible ? make.trailing.equalToSuperview() : make.leading.equalTo(view.snp.trailing)
            make.top.equalTo(50*Constants.standardHeight)
            make.bottom.equalToSuperview()
        }
        
        backgroundView.isHidden = !isVisible
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .allowAnimatedContent) {
            self.backgroundView.alpha = isVisible ? 0.3 : 0
            self.view.layoutIfNeeded()
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
