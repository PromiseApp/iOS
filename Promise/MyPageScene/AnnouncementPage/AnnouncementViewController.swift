import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit

class AnnouncementViewController: UIViewController {
    let disposeBag = DisposeBag()
    var announcementViewModel: AnnouncementViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    lazy var announcementTableView = UITableView()
    
    init(announcementViewModel: AnnouncementViewModel) {
        self.announcementViewModel = announcementViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        attribute()
        layout()
        bind()
    }
    
    private func bind(){
        leftButton.rx.tap
            .bind(to: announcementViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        announcementTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<AnnouncementSectionModel>(
            configureCell: { (dataSource, tableView, indexPath, announcementContent) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "AnnouncementTableViewCell", for: indexPath) as! AnnouncementTableViewCell
                cell.configure(content: announcementContent.content)
                return cell
            }
        )
        
        announcementViewModel.announcementDriver
            .map { announcement in
                announcement.map { AnnouncementSectionModel(model: $0, items: $0.isExpanded ? [$0.announcementContent] : []) }
            }
            .drive(announcementTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "공지사항"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        announcementTableView.do{
            $0.separatorStyle = .none
            $0.register(AnnouncementTableViewCell.self, forCellReuseIdentifier: "AnnouncementTableViewCell")
            $0.register(AnnouncementHeaderView.self, forHeaderFooterViewReuseIdentifier: "AnnouncementHeaderView")
            $0.sectionHeaderTopPadding = 0
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,announcementTableView]
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
        
        announcementTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom)
        }
        
    }

}

typealias AnnouncementSectionModel = SectionModel<AnnouncementHeader, AnnouncementCell>
extension AnnouncementViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "AnnouncementHeaderView") as! AnnouncementHeaderView
        let announment = announcementViewModel.announcementRelay.value[section]
        header.configure(title: announment.title, date: announment.date, isExpanded: announment.isExpanded)
        header.direButton.rx.tap
            .bind { [weak self] in
                self?.announcementViewModel.toggleSectionExpansion(at: section)
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
