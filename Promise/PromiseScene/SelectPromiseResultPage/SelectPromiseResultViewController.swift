import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit

class SelectPromiseResultViewController: UIViewController {
    let disposeBag = DisposeBag()
    var selectPromiseResultViewModel: SelectPromiseResultViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let noResultLabel = UILabel()
    lazy var promiseListTableView = UITableView()
    
    init(selectPromiseResultViewModel: SelectPromiseResultViewModel) {
        self.selectPromiseResultViewModel = selectPromiseResultViewModel
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
            .bind(to: selectPromiseResultViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        promiseListTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<PromiseSectionModel>(
            configureCell: { [weak self] (dataSource, tableView, indexPath, promiseView) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "SelectPromiseResultTableViewCell", for: indexPath) as! SelectPromiseResultTableViewCell
                cell.configure(data: promiseView)
                cell.selectMemberResultButton.rx.tap
                    .bind(to: (self?.selectPromiseResultViewModel.selectMemberResultButtonTapped)!)
                    .disposed(by: cell.disposeBag)
                return cell
            }
        )
        
        selectPromiseResultViewModel.resultPromiseDriver
            .map { promises in
                promises.map { PromiseSectionModel(model: $0, items: $0.isExpanded ? $0.promises : []) }
            }
            .drive(promiseListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "결과 선택"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        noResultLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.text = "아직 결과를 선택할 약속이 없어요!\n약속 시간이 지나면 결과를 선택해주세요 :)"
            $0.textColor = UIColor(named: "greyFour")
        }
        
        promiseListTableView.do{
            $0.separatorStyle = .singleLine
            $0.register(SelectPromiseResultTableViewCell.self, forCellReuseIdentifier: "SelectPromiseResultTableViewCell")
            $0.register(PromiseHeaderCell.self, forHeaderFooterViewReuseIdentifier: "PromiseHeaderCell")
            $0.sectionHeaderTopPadding = 0
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,noResultLabel,promiseListTableView]
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
        
        noResultLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        promiseListTableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom)
        }
        
    }
    
}

extension SelectPromiseResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PromiseHeaderCell") as! PromiseHeaderCell
        let promise = selectPromiseResultViewModel.resultPromiseRelay.value[section]
        header.configure(date: promise.date, isExpanded: promise.isExpanded)
        
        header.direButton.rx.tap
            .bind { [weak self] in
                self?.selectPromiseResultViewModel.toggleSectionExpansion(at: section)
            }
            .disposed(by: header.disposeBag)
        
        return header
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
