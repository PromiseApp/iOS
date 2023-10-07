import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class FriendViewController: UIViewController {
    var disposeBag = DisposeBag()
    var friendViewModel:FriendViewModel
    weak var friendCoordinator: FriendCoordinator?
    
    let titleLabel = UILabel()
    let addFriendButton = UIButton()
    let separateView = UIView()
    lazy var searchImageView = UIImageView()
    let searchTextField = UITextField()
    let editButton = UIButton()
    let deleteButton = UIButton()
    let cancelButton = UIButton()
    lazy var tableView = UITableView()
        
    init(friendViewModel: FriendViewModel, friendCoordinator: FriendCoordinator?) {
        self.friendViewModel = friendViewModel
        self.friendCoordinator = friendCoordinator
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
        
        addFriendButton.rx.tap
            .subscribe(onNext: {
                
            })
            .disposed(by: disposeBag)


        searchTextField.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [weak self] query in
                self?.friendViewModel.search(query: query)
            }
            .disposed(by: disposeBag)
        
        friendViewModel.friendDatas
            .drive(tableView.rx.items(cellIdentifier: "FriendTableViewCell", cellType: FriendTableViewCell.self)) { row, friend, cell in
                cell.configure(with: friend)
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.friendViewModel.toggleSelection(at: indexPath.row)
            }
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "친구"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        addFriendButton.do{
            $0.setImage(UIImage(named: "addFriend"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        searchImageView.do{
            $0.image = UIImage(named: "search")
        }
        
        searchTextField.do{
            $0.placeholder = "친구를 검색해보세요"
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prLight")
            $0.addLeftPadding(width: 40*Constants.standardWidth)
            $0.layer.cornerRadius = 20*Constants.standardHeight
        }
        
        editButton.do{
            $0.setTitle("편집", for: .normal)
            $0.setTitleColor(UIColor(named: "greyTwo"), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 11*Constants.standartFont)
        }
        
        deleteButton.do{
            $0.setTitle("삭제", for: .normal)
            $0.setTitleColor(UIColor(named: "greyTwo"), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 11*Constants.standartFont)
            $0.isHidden = true
        }
        
        cancelButton.do{
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(UIColor(named: "greyTwo"), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 11*Constants.standartFont)
            $0.isHidden = true
        }
        
        tableView.do{
            $0.separatorStyle = .none
            $0.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendTableViewCell")
        }
        
    }
    
    private func layout(){
        [titleLabel,addFriendButton,separateView,searchTextField,searchImageView,editButton,deleteButton,cancelButton,tableView]
            .forEach{ view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(56*Constants.standardHeight)
        }
        
        addFriendButton.snp.makeConstraints { make in
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
        
        searchTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        searchImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalTo(searchTextField.snp.leading).offset(12*Constants.standardWidth)
            make.centerY.equalTo(searchTextField)
        }
        
        editButton.snp.makeConstraints { make in
            make.trailing.equalTo(searchTextField.snp.trailing)
            make.top.equalTo(searchTextField.snp.bottom).offset(16*Constants.standardHeight)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.trailing.equalTo(searchTextField.snp.trailing)
            make.top.equalTo(searchTextField.snp.bottom).offset(16*Constants.standardHeight)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.trailing.equalTo(searchTextField.snp.leading).offset(8*Constants.standardWidth)
            make.top.equalTo(searchTextField.snp.bottom).offset(16*Constants.standardHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(editButton.snp.bottom)
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
