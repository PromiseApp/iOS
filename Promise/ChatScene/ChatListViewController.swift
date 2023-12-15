import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class ChatListViewController: UIViewController {
    let disposeBag = DisposeBag()
    var chatListViewModel: ChatListViewModel
    
    let titleLabel = UILabel()
    let separateView = UIView()
    let chatListTableView = UITableView()
        
    init(chatListViewModel: ChatListViewModel) {
        self.chatListViewModel = chatListViewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.chatListViewModel.loadChatList()
    }
    
    private func bind(){
        
        chatListViewModel.chatListDriver
            .drive(chatListTableView.rx.items(cellIdentifier: "ChatListTableViewCell", cellType: ChatListTableViewCell.self)){ row, chatList, cell in
                cell.configure(chatList: chatList)
            }
            .disposed(by: disposeBag)
        
        chatListTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let cell = self?.chatListTableView.cellForRow(at: indexPath) as? ChatListTableViewCell else { return }
                let promiseID = cell.promiseID
                self?.chatListViewModel.cellSelected.accept(promiseID)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "채팅방"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        chatListTableView.do{
            $0.separatorStyle = .none
            $0.register(ChatListTableViewCell.self, forCellReuseIdentifier: "ChatListTableViewCell")
        }
        
    }
    
    private func layout(){
        [titleLabel,separateView,chatListTableView]
            .forEach{ view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(56*Constants.standardHeight)
        }
        
        separateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        chatListTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom)
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
