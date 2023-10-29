import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class FriendViewController: UIViewController {
    var disposeBag = DisposeBag()
    var friendViewModel:FriendViewModel
    
    let titleLabel = UILabel()
    let settingButton = UIButton()
    let separateView = UIView()
    let settingView = UIView()
    let addFriendButton = UIButton()
    let secSeparateView = UIView()
    let requestFriendButton = UIButton()
    lazy var searchImageView = UIImageView()
    let searchTextField = UITextField()
    lazy var tableView = UITableView()
        
    init(friendViewModel: FriendViewModel) {
        self.friendViewModel = friendViewModel
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

        settingButton.rx.tap
            .map { !self.settingView.isHidden }
            .bind(to: settingView.rx.isHidden)
            .disposed(by: disposeBag)

        
        addFriendButton.rx.tap
            .bind(to: friendViewModel.addFriendButtonTapped)
            .disposed(by: disposeBag)
        
        requestFriendButton.rx.tap
            .bind(to: friendViewModel.requestFriendButtonTapped)
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
                cell.isHiddenSelectImageView(with: true)
            }
            .disposed(by: disposeBag)

    }
    
    private func attribute(){
        self.view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "친구"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        settingButton.do{
            $0.setImage(UIImage(named: "setting"), for: .normal)
        }
        
        settingView.do{
            $0.layer.cornerRadius = 5*Constants.standardHeight
            $0.layer.shadowOffset = CGSize(width: 5*Constants.standardWidth, height: 5*Constants.standardHeight)
            $0.layer.shadowRadius = 5*Constants.standardHeight
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.5
            $0.backgroundColor = UIColor(named: "prLight")
            $0.isHidden = true
        }
        
        addFriendButton.do{
            $0.setTitle("친구 추가", for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
            $0.setTitleColor(.black, for: .normal)
        }
        
        secSeparateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        requestFriendButton.do{
            $0.setTitle("친구 요청", for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
            $0.setTitleColor(.black, for: .normal)
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
        
        tableView.do{
            $0.separatorStyle = .none
            $0.rowHeight = 48*Constants.standardHeight
            $0.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendTableViewCell")
        }
        
    }
    
    private func layout(){
        [titleLabel,settingButton,separateView,searchTextField,searchImageView,settingView,tableView]
            .forEach{ view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(56*Constants.standardHeight)
        }
        
        settingButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        settingView.snp.makeConstraints { make in
            make.width.equalTo(120*Constants.standardWidth)
            make.height.equalTo(65*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.top.equalTo(settingButton.snp.bottom).offset(4*Constants.standardHeight)
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
        
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(16*Constants.standardHeight)
            make.bottom.equalToSuperview()
        }
        
        [addFriendButton,secSeparateView,requestFriendButton]
            .forEach{settingView.addSubview($0)}

        addFriendButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(32*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }

        secSeparateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(addFriendButton.snp.bottom)
        }

        requestFriendButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(32*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(secSeparateView.snp.bottom)
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
