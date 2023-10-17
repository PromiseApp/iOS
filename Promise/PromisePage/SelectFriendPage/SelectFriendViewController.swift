import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class SelectFriendViewController: UIViewController {
    var disposeBag = DisposeBag()
    var selectFriendViewModel:SelectFriendViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let secSeparateView = UIView()
    lazy var searchImageView = UIImageView()
    let searchTextField = UITextField()
    lazy var tableView = UITableView()
    let nextButton = UIButton()
        
    init(selectFriendViewModel: SelectFriendViewModel) {
        self.selectFriendViewModel = selectFriendViewModel
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
            .bind(to: selectFriendViewModel.leftButtonTapped)
            .disposed(by: disposeBag)


        searchTextField.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [weak self] query in
                self?.selectFriendViewModel.search(query: query)
            }
            .disposed(by: disposeBag)
        
        selectFriendViewModel.friendDatas
            .drive(tableView.rx.items(cellIdentifier: "FriendTableViewCell", cellType: FriendTableViewCell.self)) { row, friend, cell in
                cell.configure(with: friend)
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind { [weak self] indexPath in
                self?.selectFriendViewModel.toggleSelection(at: indexPath.row)
            }
            .disposed(by: disposeBag)
        
        selectFriendViewModel.friendDatas
            .map { friends in
                friends.contains { $0.isSelected }
            }
            .drive(onNext: { [weak self] bool in
                if(bool){
                    self?.nextButton.alpha = 1
                    self?.nextButton.isEnabled = true
                }
                else{
                    self?.nextButton.alpha = 0.3
                    self?.nextButton.isEnabled = false
                }
            })
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(to: selectFriendViewModel.nextButtonTapped)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "친구 선택"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        [separateView,secSeparateView]
            .forEach{
                $0.backgroundColor = UIColor(named: "line")
            }
        
        searchImageView.do{
            $0.image = UIImage(named: "search")
        }
        
        searchTextField.do{
            $0.placeholder = "친구를 검색해보세요"
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
        }
        
        tableView.do{
            $0.separatorStyle = .none
            $0.register(FriendTableViewCell.self, forCellReuseIdentifier: "FriendTableViewCell")
        }
        
        nextButton.do{
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.alpha = 0.3
            $0.isEnabled = false
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,searchImageView,searchTextField,secSeparateView,nextButton,tableView]
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
        
        searchImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.width.equalTo(310*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalTo(searchImageView.snp.trailing).offset(4*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom)
        }
        
        secSeparateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom)
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(48*Constants.standardWidth)
            make.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(secSeparateView.snp.bottom)
            make.bottom.equalTo(nextButton.snp.top)
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
