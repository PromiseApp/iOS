import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class RequestFriendViewController: UIViewController {
    var disposeBag = DisposeBag()
    var requestFriendViewModel: RequestFriendViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    lazy var tableView = UITableView()
        
    init(requestFriendViewModel: RequestFriendViewModel) {
        self.requestFriendViewModel = requestFriendViewModel
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
            .bind(to: requestFriendViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        requestFriendViewModel.friendDatas
            .drive(tableView.rx.items(cellIdentifier: "RequestFriendTableViewCell", cellType: RequestFriendTableViewCell.self)) { row, friend, cell in
                cell.configure(with: friend)
                
                cell.rejectButton.rx.tap
                    .subscribe(onNext: { [weak self, weak cell] in
                        if let requesterID = cell?.requesterID {
                            self?.requestFriendViewModel.rejectButtonTapped.accept(requesterID)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.acceptButton.rx.tap
                    .subscribe(onNext: { [weak self, weak cell] in
                        if let requesterID = cell?.requesterID {
                            self?.requestFriendViewModel.acceptButtonTapped.accept(requesterID)
                        }
                    })
                    .disposed(by: cell.disposeBag)
                
                
            }
            .disposed(by: disposeBag)
        
        requestFriendViewModel.rejectFriendSuccessViewModel.requestSuccessRelay
            .subscribe(onNext: { [weak self] requesterID in
                self?.requestFriendViewModel.allFriends.removeAll { $0.requesterID == requesterID }
                self?.requestFriendViewModel.friendsRelay.accept(self?.requestFriendViewModel.allFriends ?? [])
            })
            .disposed(by: disposeBag)

    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "친구 요청"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        tableView.do{
            $0.separatorStyle = .none
            $0.rowHeight = 48*Constants.standardHeight
            $0.register(RequestFriendTableViewCell.self, forCellReuseIdentifier: "RequestFriendTableViewCell")
        }
        
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,tableView]
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
        
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom)
            make.bottom.equalToSuperview()
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
