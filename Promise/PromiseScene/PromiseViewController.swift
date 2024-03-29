import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import SnapKit
import Then

class PromiseViewController: UIViewController {
    let disposeBag = DisposeBag()
    var promiseViewModel: PromiseViewModel
    
    let logoLabel = UILabel()
    let bellButton = UIButton()
    let firstSeparateView = UIView()
    let secSeparateView = UIView()
    let thirdSeparateView = UIView()
    let dateLabel = UILabel()
    let downButton = UIButton()
    let viewPastPromiseButton = UIButton()
    lazy var progressView = DonutProgressView()
    lazy var levelLabel = UILabel()
    lazy var expLabel = UILabel()
    lazy var cntLabel = UILabel()
    let selectPromiseResultButton = UIButton()
    let refreshControl = UIRefreshControl()
    lazy var promiseListTableView = UITableView()
    let plusButton = UIButton()
    let newPromiseButton = UIButton()
    let newImageView = UIImageView()
    
    var years: [Int] = Array(2000...2100)
    var months: [Int] = Array(1...12)
    var tabBarHeight: CGFloat = 0.0
    
    init(promiseViewModel: PromiseViewModel) {
        self.promiseViewModel = promiseViewModel
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
        notiSetting()
        promiseViewModel.loadNewPromiseList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.promiseViewModel.loadPromiseList()
        self.promiseViewModel.loadNotDetPromiseList()
        self.promiseViewModel.loadLevelExp()
    }
    
    private func notiSetting(){
        let newPromiseRequestNotificationReceived = UserDefaults.standard.bool(forKey: UserDefaultsKeys.newPromiseRequestNotificationReceived)
        newImageView.isHidden = !newPromiseRequestNotificationReceived
    }
    
    private func bind(){
        
        promiseViewModel.yearAndMonth
            .map { "\($0.year!)년 \($0.month!)월" }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        downButton.rx.tap
            .bind { [weak self] in
                self?.showDatePicker()
            }
            .disposed(by: disposeBag)
        
        plusButton.rx.tap
            .bind(to: promiseViewModel.plusButtonTapped)
            .disposed(by: disposeBag)
        
        viewPastPromiseButton.rx.tap
            .bind(to: promiseViewModel.viewPastPromiseButtonTapped)
            .disposed(by: disposeBag)
        
        selectPromiseResultButton.rx.tap
            .bind(to: promiseViewModel.selectPromiseResultButtonTapped)
            .disposed(by: disposeBag)
        
        newPromiseButton.rx.tap
            .bind(to: promiseViewModel.newPromiseButtonTapped)
            .disposed(by: disposeBag)
        
        promiseViewModel.levelRelay
            .subscribe(onNext: {[weak self] level in
                self?.levelLabel.text = "Lv \(level)"
            })
            .disposed(by: disposeBag)
        
        promiseViewModel.expRelay
            .subscribe(onNext: { [weak self] exp in
                self?.expLabel.text = "\(exp)/10"
                self?.progressView.progress = CGFloat(Float(exp) / 10.0)
            })
            .disposed(by: disposeBag)
        
        promiseListTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<PromiseSectionModel>(
            configureCell: { [weak self] (dataSource, tableView, indexPath, promiseView) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "PromiseTableViewCell", for: indexPath) as! PromiseTableViewCell
                cell.configure(data: promiseView)
                cell.modifyButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        var type = ""
                        if(cell.manger){
                            type = "isManager"
                        }
                        else{
                            type = "isNotManager"
                        }
                        self?.promiseViewModel.modifyButtonTapped.accept((cell.id,type))
                    })
                    .disposed(by: cell.disposeBag)
                return cell
            }
        )

        promiseViewModel.promiseDriver
            .map { promises in
                promises.map { PromiseSectionModel(model: $0, items: $0.isExpanded ? $0.promises : []) }
            }
            .drive(promiseListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        promiseViewModel.cntNotDetPromise
            .subscribe(onNext: { [weak self] cnt in
                if(cnt == 0){
                    self?.cntLabel.text = "아직 결과를 선택할 약속이 없어요 :)"
                    self?.selectPromiseResultButton.isHidden = true
                }
                else{
                    let text = "결과 선택할 약속 : \(cnt)"
                    let attributedString = NSMutableAttributedString(string: text)
                    
                    attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "\(cnt)"))
                    
                    self?.cntLabel.attributedText = attributedString
                    self?.selectPromiseResultButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        promiseViewModel.promisesRelay
            .subscribe(onNext: { [weak self] promises in
                if(promises.count == 0){
                    self?.promiseListTableView.isHidden = true
                    self?.plusButton.isHidden = false
                }
                else{
                    self?.promiseListTableView.isHidden = false
                    self?.plusButton.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                self?.promiseViewModel.loadPromiseList()
            })
            .disposed(by: disposeBag)
        
        promiseViewModel.dataLoading
            .bind(onNext: { [weak self] loading in
                if(loading){
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name("newPromiseRequestNotificationReceived"))
            .subscribe(onNext: { [weak self] _ in
                self?.newImageView.isHidden = false
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(Notification.Name("newPromiseRequestNotificationRead"))
            .subscribe(onNext: { [weak self] _ in
                self?.newImageView.isHidden = true
            })
            .disposed(by: disposeBag)
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        logoLabel.do{
            $0.text = "PlaMeet"
            $0.font = UIFont(name: "Sriracha-Regular", size: 24*Constants.standartFont)
            $0.textColor = UIColor(named: "prStrong")
        }
        
        bellButton.do{
            $0.setImage(UIImage(named: "bell"), for: .normal)
            $0.isHidden = true
        }
        
        [firstSeparateView,secSeparateView,thirdSeparateView]
            .forEach{ $0.backgroundColor = UIColor(named: "line") }
        
        dateLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
        }
        
        downButton.do{
            $0.setImage(UIImage(named: "downTwo"), for: .normal)
        }
        
        viewPastPromiseButton.do{
            $0.setTitle("지난 약속 보기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.setImage(UIImage(named: "right"), for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft
        }
        
        levelLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 24*Constants.standartFont)
            $0.textColor = UIColor(hexCode: "F59564")
        }
        
        expLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        cntLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
        }
        
        selectPromiseResultButton.do{
            $0.setTitle("결과 선택하기", for: .normal)
            $0.setTitleColor(UIColor(named: "prHeavy"), for: .normal)
            $0.setImage(UIImage(named: "rightPrHeavy"), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.semanticContentAttribute = .forceRightToLeft
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor(named: "prHeavy")?.cgColor
            $0.layer.cornerRadius = 13*Constants.standardHeight
        }
        
        plusButton.do{
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 12 * Constants.standardHeight
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 24 * Constants.standartFont)
            let text = "약속을 만들어볼까요?"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "약속"))

            $0.setAttributedTitle(attributedString, for: .normal)
            $0.setImage(UIImage(named: "plus"), for: .normal)
            $0.alignTextBelow(spacing: 40*Constants.standardHeight)
        }
        
        promiseListTableView.do{
            $0.separatorStyle = .singleLine
            $0.register(PromiseTableViewCell.self, forCellReuseIdentifier: "PromiseTableViewCell")
            $0.register(PromiseHeaderCell.self, forHeaderFooterViewReuseIdentifier: "PromiseHeaderCell")
            $0.sectionHeaderTopPadding = 0
            $0.refreshControl = refreshControl
        }
        
        newPromiseButton.do{
            $0.setTitle("새로운 약속", for: .normal)
            $0.setTitleColor(UIColor(named: "prHeavy"), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
            $0.setImage(UIImage(named: "rightPrHeavy"), for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft
            $0.layer.cornerRadius = 16*Constants.standardHeight
            $0.layer.borderColor = UIColor(named: "prHeavy")?.cgColor
            $0.layer.borderWidth = 2
        }
        
        newImageView.do{
            $0.image = UIImage(named: "new")
            $0.layer.cornerRadius = 6*Constants.standardHeight
            $0.isHidden = true
        }
        
    }
    
    private func layout(){
        [logoLabel,bellButton,dateLabel,downButton,firstSeparateView,viewPastPromiseButton,progressView,levelLabel,expLabel,secSeparateView,cntLabel,selectPromiseResultButton,thirdSeparateView,promiseListTableView,plusButton,newPromiseButton,newImageView]
            .forEach{view.addSubview($0)}
        
        logoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(12*Constants.standardHeight)
        }
        
        bellButton.snp.makeConstraints { make in
            make.width.height.equalTo(36*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalTo(logoLabel)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(76*Constants.standardHeight)
        }
        
        downButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalTo(dateLabel.snp.trailing)
            make.centerY.equalTo(dateLabel)
        }
        
        firstSeparateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(dateLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        viewPastPromiseButton.snp.makeConstraints { make in
            make.width.equalTo(94*Constants.standardWidth)
            make.height.equalTo(16*Constants.standardHeight)
            make.trailing.equalToSuperview()
            make.top.equalTo(firstSeparateView.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        progressView.snp.makeConstraints { make in
            make.width.equalTo(177*Constants.standardWidth)
            make.height.equalTo(158*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(firstSeparateView.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstSeparateView.snp.bottom).offset(66*Constants.standardHeight)
        }
        
        expLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(levelLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        secSeparateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(progressView.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        cntLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(secSeparateView.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        selectPromiseResultButton.snp.makeConstraints { make in
            make.width.equalTo(105*Constants.standardWidth)
            make.height.equalTo(26*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.centerY.equalTo(cntLabel)
        }
        
        thirdSeparateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(cntLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        promiseListTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(thirdSeparateView.snp.bottom)
        }
        
        plusButton.snp.makeConstraints { make in
            make.width.equalTo(333*Constants.standardWidth)
            make.height.equalTo(200*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(thirdSeparateView.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        newPromiseButton.snp.makeConstraints { make in
            make.width.equalTo(100*Constants.standardWidth)
            make.height.equalTo(32*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-12*Constants.standardHeight)
        }
        
        newImageView.snp.makeConstraints { make in
            make.width.height.equalTo(12*Constants.standardHeight)
            make.leading.equalTo(newPromiseButton.snp.leading)
            make.top.equalTo(newPromiseButton.snp.top)
        }
        
    }
    
    func showDatePicker() {
        let alert = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        alert.view.addSubview(picker)
        
        let titleFont = UIFont.systemFont(ofSize: 17)
        let titleLineHeight = titleFont.lineHeight
        let numberOfTitleLines = 6
        let titleHeight = titleLineHeight * CGFloat(numberOfTitleLines)

        picker.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(titleHeight)
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
            self?.promiseViewModel.yearAndMonth.accept((year: selectedYear, month: selectedMonth))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension PromiseViewController: UIPickerViewDelegate,UIPickerViewDataSource{

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

typealias PromiseSectionModel = SectionModel<PromiseHeader, PromiseCell>
extension PromiseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PromiseHeaderCell") as! PromiseHeaderCell
        let promise = promiseViewModel.promisesRelay.value[section]
        header.configure(date: promise.date, isExpanded: promise.isExpanded)
        
        header.direButton.rx.tap
            .bind { [weak self] in
                self?.promiseViewModel.toggleSectionExpansion(at: section)
            }
            .disposed(by: header.disposeBag)
        
        return header
    }
}
