import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class FriendViewController: UIViewController {
    var disposeBag = DisposeBag()
    var friendViewModel:FriendViewModel
    var addFriendPopupViewModel: AddFriendPopupViewModel
    
    let titleLabel = UILabel()
    let settingButton = UIButton()
    let separateView = UIView()
    let settingView = UIView()
    let firstNewImageView = UIImageView()
    let secondNewImageView = UIImageView()
    let addFriendButton = UIButton()
    let secSeparateView = UIView()
    let requestFriendButton = UIButton()
    lazy var searchImageView = UIImageView()
    let searchTextField = UITextField()
    let refreshControl = UIRefreshControl()
    lazy var tableView = UITableView()
    let successView = UIView()
    let successLabel = UILabel()
        
    init(friendViewModel: FriendViewModel, addFriendPopupViewModel: AddFriendPopupViewModel) {
        self.friendViewModel = friendViewModel
        self.addFriendPopupViewModel = addFriendPopupViewModel
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
        self.friendViewModel.loadFriendList()
    }
    
    private func bind(){

        settingButton.rx.tap
            .map { !self.settingView.isHidden }
            .bind(to: settingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        friendViewModel.settingViewRelay
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
        
        addFriendPopupViewModel.requestSuccessRelay
            .subscribe(onNext: { [weak self] nickname in
                self?.showSuccessView(nickname: nickname)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                self?.friendViewModel.loadFriendList()
            })
            .disposed(by: disposeBag)
        
        friendViewModel.dataLoading
            .bind(onNext: { [weak self] loading in
                if(loading){
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name("newFriendRequestNotificationReceived"))
            .subscribe(onNext: { [weak self] _ in
                self?.firstNewImageView.isHidden = false
                self?.secondNewImageView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name("newFriendRequestNotificationRead"))
            .subscribe(onNext: { [weak self] _ in
                self?.firstNewImageView.isHidden = true
                self?.secondNewImageView.isHidden = true
            })
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
        
        [firstNewImageView,secondNewImageView]
            .forEach{
                $0.image = UIImage(named: "new")
                $0.layer.cornerRadius = 6*Constants.standardHeight
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
            $0.titleLabel?.textAlignment = .center
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
            $0.refreshControl = refreshControl
        }
        
        successView.do{
            $0.backgroundColor = UIColor(named: "prLight")
            $0.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowRadius = 2*Constants.standardHeight
            $0.layer.shadowOffset = CGSize(width: 2*Constants.standardWidth, height: 2*Constants.standardHeight)
            $0.layer.cornerRadius = 8*Constants.standardHeight
            $0.isHidden = true
        }
        
        successLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
        }
        
    }
    
    private func layout(){
        [titleLabel,settingButton,firstNewImageView,separateView,searchTextField,searchImageView,settingView,tableView,successView]
            .forEach{ view.addSubview($0) }
        
        successView.addSubview(successLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(56*Constants.standardHeight)
        }
        
        settingButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        firstNewImageView.snp.makeConstraints { make in
            make.width.height.equalTo(12*Constants.standardHeight)
            make.leading.equalTo(settingButton.snp.leading)
            make.top.equalTo(settingButton.snp.top)
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
        
        successView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(32*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12*Constants.standardHeight)
        }
        
        successLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        [addFriendButton,secSeparateView,requestFriendButton,secondNewImageView]
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
        
        settingView.bringSubviewToFront(secondNewImageView)
        
        secondNewImageView.snp.makeConstraints { make in
            make.width.height.equalTo(12*Constants.standardHeight)
            make.trailing.equalTo(requestFriendButton.titleLabel!.snp.leading)
            make.top.equalTo(requestFriendButton.titleLabel!.snp.top)
        }
        
    }
    
    private func showSuccessView(nickname: String){
        successLabel.text = "\(nickname)님에게 친구 요청을 보냈습니다!"
        successView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.successView.isHidden = true
        }
    }
    
}
