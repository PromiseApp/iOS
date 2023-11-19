import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit

class PastPromiseViewController: UIViewController {
    let disposeBag = DisposeBag()
    var pastPromiseViewModel: PastPromiseViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let dateLabel = UILabel()
    let downButton = UIButton()
    let secSeparateView = UIView()
    lazy var searchImageView = UIImageView()
    let searchTextField = UITextField()
    let thirdSeparateView = UIView()
    lazy var promiseListTableView = UITableView()
    
    var years: [Int] = Array(2000...2100)
    var months: [Int] = Array(1...12)
    
    init(pastPromiseViewModel: PastPromiseViewModel) {
        self.pastPromiseViewModel = pastPromiseViewModel
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
            .bind(to: pastPromiseViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        pastPromiseViewModel.yearAndMonth
            .map { "\($0.year!)년 \($0.month!)월" }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        downButton.rx.tap
            .bind { [weak self] in
                self?.showDatePicker()
            }
            .disposed(by: disposeBag)
        
        promiseListTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<PromiseSectionModel>(
            configureCell: { (dataSource, tableView, indexPath, promiseView) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "PromiseTableViewCell", for: indexPath) as! PromiseTableViewCell
                cell.configure(data: promiseView)
                cell.modifyButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.pastPromiseViewModel.modifyButtonTapped.accept((cell.id,"past"))
                    })
                    .disposed(by: cell.disposeBag)
                return cell
            }
        )
        
        pastPromiseViewModel.pastPromiseDatas
            .map { promises in
                promises.map { PromiseSectionModel(model: $0, items: $0.isExpanded ? $0.promises : []) }
            }
            .drive(promiseListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        searchTextField.rx.text
            .orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind { [weak self] query in
                self?.pastPromiseViewModel.search(query: query)
            }
            .disposed(by: disposeBag)

        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "지난 약속"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        [separateView,secSeparateView,thirdSeparateView]
            .forEach{
                $0.backgroundColor = UIColor(named: "line")
            }
        
        dateLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
        }
        
        downButton.do{
            $0.setImage(UIImage(named: "downTwo"), for: .normal)
        }
        
        searchImageView.do{
            $0.image = UIImage(named: "search")
        }
        
        searchTextField.do{
            $0.placeholder = "제목을 입력해주세요"
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prLight")
            $0.addLeftPadding(width: 40*Constants.standardWidth)
            $0.layer.cornerRadius = 20*Constants.standardHeight
        }
        
        promiseListTableView.do{
            $0.separatorStyle = .singleLine
            $0.register(PromiseTableViewCell.self, forCellReuseIdentifier: "PromiseTableViewCell")
            $0.register(PromiseHeaderCell.self, forHeaderFooterViewReuseIdentifier: "PromiseHeaderCell")
            $0.sectionHeaderTopPadding = 0
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,dateLabel,downButton,secSeparateView,searchTextField,searchImageView,thirdSeparateView,promiseListTableView]
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
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        downButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalTo(dateLabel.snp.trailing)
            make.centerY.equalTo(dateLabel)
        }
        
        secSeparateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(secSeparateView.snp.bottom).offset(16*Constants.standardHeight)
        }
        
        searchImageView.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalTo(searchTextField.snp.leading).offset(12*Constants.standardWidth)
            make.centerY.equalTo(searchTextField)
        }
        
        thirdSeparateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(16*Constants.standardHeight)
        }
        
        promiseListTableView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(thirdSeparateView.snp.bottom)
        }
        
    }
    
    func showDatePicker() {
        let alert = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        alert.view.addSubview(picker)
        
        picker.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(150*Constants.standardHeight)
        }
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date()) - 1
        if let yearIndex = years.firstIndex(of: currentYear) {
            picker.selectRow(yearIndex, inComponent: 0, animated: false)
        }
        picker.selectRow(currentMonth, inComponent: 1, animated: false)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            let selectedYear = self?.years[picker.selectedRow(inComponent: 0)]
            let selectedMonth = self?.months[picker.selectedRow(inComponent: 1)]
            self?.pastPromiseViewModel.yearAndMonth.onNext((year: selectedYear, month: selectedMonth))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension PastPromiseViewController: UIPickerViewDelegate,UIPickerViewDataSource{

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return years.count
        } else {
            return months.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(years[row])년"
        } else {
            return "\(months[row])월"
        }
    }
}

extension PastPromiseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PromiseHeaderCell") as! PromiseHeaderCell
        let promise = pastPromiseViewModel.pastPromisesRelay.value[section]
        header.configure(date: promise.date, isExpanded: promise.isExpanded)
        
        header.direButton.rx.tap
            .bind { [weak self] in
                self?.pastPromiseViewModel.toggleSectionExpansion(at: section)
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
