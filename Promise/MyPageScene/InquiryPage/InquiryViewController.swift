import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit

class InquiryViewController: UIViewController {
    let disposeBag = DisposeBag()
    var inquiryViewModel: InquiryViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let writeButton = UIButton()
    let separateView = UIView()
    let stateLabel = UILabel()
    let firstSepaView = UIView()
    let stateValueLabel = UILabel()
    let periodLabel = UILabel()
    let secondSepaView = UIView()
    let periodValueLabel = UILabel()
    let rightButton = UIButton()
    let secSeparateView = UIView()
    let conditionView = UIView()
    let secStateLabel = UILabel()
    let stateCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 117*Constants.standardWidth, height: 30*Constants.standardHeight)
        $0.minimumLineSpacing = 0
    })
    let secPeriodLabel = UILabel()
    let periodCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 87.75*Constants.standardWidth, height: 30*Constants.standardHeight)
        $0.minimumLineSpacing = 0
    })
    lazy var inquiryTableView = UITableView()
    
    init(inquiryViewModel: InquiryViewModel) {
        self.inquiryViewModel = inquiryViewModel
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inquiryViewModel.loadInquiryList()
    }
    
    private func bind(){

        inquiryViewModel.isMasterRelay
            .bind(to: self.writeButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        leftButton.rx.tap
            .bind(to: inquiryViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        writeButton.rx.tap
            .bind(to: inquiryViewModel.writeButtonTapped)
            .disposed(by: disposeBag)
        
        rightButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.conditionView.isHidden.toggle()
                let imageName = self?.conditionView.isHidden ?? true ? "right" : "down"
                self?.rightButton.setImage(UIImage(named: imageName), for: .normal)
                
            })
            .disposed(by: disposeBag)
        
        inquiryViewModel.stateCondition
            .bind(to: stateCollectionView.rx.items(cellIdentifier: "InquiryConditionCollectionViewCell", cellType: InquiryConditionCollectionViewCell.self)) { (row, element, cell) in
                cell.configure(text: element)
                if(row == 0){
                    cell.backgroundColor = UIColor(named: "prStrong")
                }
            }
            .disposed(by: disposeBag)
        
        stateCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.stateCollectionView.cellForItem(at: indexPath)
                cell?.backgroundColor = UIColor(named: "prStrong")
                if indexPath.item != 0 {
                    let firstCell = self?.stateCollectionView.cellForItem(at: IndexPath(item: 0, section: 0))
                    firstCell?.backgroundColor = UIColor(named: "prLight")
                }
                switch indexPath.item{
                case 0:
                    self?.stateValueLabel.text = "전체"
                    self?.inquiryViewModel.stateRelay.accept("전체")
                case 1:
                    self?.stateValueLabel.text = "접수"
                    self?.inquiryViewModel.stateRelay.accept("접수")
                case 2:
                    self?.stateValueLabel.text = "답변완료"
                    self?.inquiryViewModel.stateRelay.accept("답변완료")
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        stateCollectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.stateCollectionView.cellForItem(at: indexPath)
                cell?.backgroundColor = UIColor(named: "prLight")
            })
            .disposed(by: disposeBag)
        
        inquiryViewModel.periodCondition
            .bind(to: periodCollectionView.rx.items(cellIdentifier: "InquiryConditionCollectionViewCell", cellType: InquiryConditionCollectionViewCell.self)) { (row, element, cell) in
                cell.configure(text: element)
                if(row == 0){
                    cell.backgroundColor = UIColor(named: "prStrong")
                }
            }
            .disposed(by: disposeBag)
        
        periodCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.periodCollectionView.cellForItem(at: indexPath)
                cell?.backgroundColor = UIColor(named: "prStrong")
                if indexPath.item != 0 {
                    let firstCell = self?.periodCollectionView.cellForItem(at: IndexPath(item: 0, section: 0))
                    firstCell?.backgroundColor = UIColor(named: "prLight")
                }
                switch indexPath.item{
                case 0:
                    self?.periodValueLabel.text = "전체"
                    self?.inquiryViewModel.periodRelay.accept("전체")
                case 1:
                    self?.periodValueLabel.text = "3개월"
                    self?.inquiryViewModel.periodRelay.accept("3개월")
                case 2:
                    self?.periodValueLabel.text = "6개월"
                    self?.inquiryViewModel.periodRelay.accept("6개월")
                case 3:
                    self?.periodValueLabel.text = "1년"
                    self?.inquiryViewModel.periodRelay.accept("1년")
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        periodCollectionView.rx.itemDeselected
            .subscribe(onNext: { [weak self] indexPath in
                let cell = self?.periodCollectionView.cellForItem(at: indexPath)
                cell?.backgroundColor = UIColor(named: "prLight")
            })
            .disposed(by: disposeBag)
        
        inquiryTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<InquirySectionModel>(
            configureCell: { (dataSource, tableView, indexPath, inquiryReplyDate) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "InquiryTableViewCell", for: indexPath) as! InquiryTableViewCell
                cell.configure(date: inquiryReplyDate.date)
                return cell
            }
        )
        
        inquiryViewModel.inquiryDriver
            .map { inquiry in
                inquiry.map { inquiryItem in
                    if let replyDate = inquiryItem.inquiryReplyDate {
                        return InquirySectionModel(model: inquiryItem, items: [replyDate])
                    } else {
                        return InquirySectionModel(model: inquiryItem, items: [])
                    }
                }
            }
            .drive(inquiryTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        inquiryTableView.rx.itemSelected
            .map { indexPath in
                let sectionModel = dataSource.sectionModels[indexPath.section]
                let inquiryItem = sectionModel.model
                return inquiryItem.id
            }
            .bind(to: inquiryViewModel.detailInquiryTapped)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "문의내역"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        writeButton.do{
            $0.setImage(UIImage(named: "write"), for: .normal)
        }
        
        [separateView,secSeparateView]
            .forEach{
                $0.backgroundColor = UIColor(named: "line")
            }
        
        [firstSepaView,secondSepaView]
            .forEach{
                $0.backgroundColor = .black
            }
        
        stateLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
            $0.text = "상태"
        }
        periodLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
            $0.text = "기간"
        }
        
        [stateValueLabel,periodValueLabel]
            .forEach{
                $0.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
                $0.text = "전체"
            }
        
        rightButton.do{
            $0.setImage(UIImage(named: "right"), for: .normal)
        }
        
        conditionView.do{
            $0.backgroundColor = UIColor(named: "prLight")
            $0.isHidden = true
        }
        
        secStateLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)
            $0.text = "상태"
        }
        
        secPeriodLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)
            $0.text = "기간"
        }
        
        [stateCollectionView,periodCollectionView]
            .forEach{
                $0.showsHorizontalScrollIndicator = false
                $0.register(InquiryConditionCollectionViewCell.self, forCellWithReuseIdentifier: "InquiryConditionCollectionViewCell")
            }
        
        inquiryTableView.do{
            $0.separatorStyle = .none
            $0.register(InquiryTableViewCell.self, forCellReuseIdentifier: "InquiryTableViewCell")
            $0.register(InquiryHeaderView.self, forHeaderFooterViewReuseIdentifier: "InquiryHeaderView")
            $0.sectionHeaderTopPadding = 0
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,writeButton,separateView,stateLabel,firstSepaView,stateValueLabel,periodLabel,secondSepaView,periodValueLabel,rightButton,secSeparateView,inquiryTableView,conditionView]
            .forEach{ view.addSubview($0) }
        
        [secStateLabel,stateCollectionView,secPeriodLabel,periodCollectionView]
            .forEach{ conditionView.addSubview($0)}
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(56*Constants.standardHeight)
        }
        
        leftButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        writeButton.snp.makeConstraints { make in
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
        
        stateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        firstSepaView.snp.makeConstraints { make in
            make.width.equalTo(1*Constants.standardWidth)
            make.height.equalTo(16*Constants.standardHeight)
            make.leading.equalTo(stateLabel.snp.trailing).offset(8*Constants.standardWidth)
            make.centerY.equalTo(stateLabel)
        }
        
        stateValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(firstSepaView.snp.trailing).offset(8*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        secondSepaView.snp.makeConstraints { make in
            make.width.equalTo(1*Constants.standardWidth)
            make.height.equalTo(16*Constants.standardHeight)
            make.leading.equalTo(periodLabel.snp.trailing).offset(8*Constants.standardWidth)
            make.centerY.equalTo(periodLabel)
        }
        
        periodValueLabel.snp.makeConstraints { make in
            make.leading.equalTo(secondSepaView.snp.trailing).offset(8*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        rightButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalTo(stateLabel)
        }
        
        secSeparateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(stateLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        inquiryTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(secSeparateView.snp.bottom)
        }
        
        conditionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(134*Constants.standardHeight)
            make.top.equalTo(secSeparateView.snp.bottom)
        }
        
        secStateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalToSuperview().offset(12*Constants.standardHeight)
        }
        
        stateCollectionView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(32*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(secStateLabel.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        secPeriodLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(stateCollectionView.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        periodCollectionView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(32*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(secPeriodLabel.snp.bottom).offset(4*Constants.standardHeight)
        }
        
    }

}

typealias InquirySectionModel = SectionModel<InquiryHeader, InquiryReplyDate>
extension InquiryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "InquiryHeaderView") as! InquiryHeaderView
        let inquiry = inquiryViewModel.inquiryRelay.value[section]
        header.configure(title: inquiry.title, date: inquiry.date, state: inquiry.reply)

        let tapGestureRecognizer = UITapGestureRecognizer()
        header.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.rx.event
            .map { _ in inquiry.id }
            .bind(to: inquiryViewModel.detailInquiryTapped)
            .disposed(by: disposeBag)
        
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
