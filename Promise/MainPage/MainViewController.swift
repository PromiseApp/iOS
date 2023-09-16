import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    var mainViewModel: MainViewModel
    
    let bellButton = UIButton()
    let firstSeparateView = UIView()
    let secSeparateView = UIView()
    let thirdSeparateView = UIView()
    let dateLabel = UILabel()
    let downButton = UIButton()
    lazy var progressView = DonutProgressView()
    lazy var levelLabel = UILabel()
    lazy var expLabel = UILabel()
    lazy var cntLabel = UILabel()
    lazy var tableView = UITableView()
    let plusButton = UIButton()
    
    var years: [Int] = Array(2000...2100)
    var months: [Int] = Array(1...12)
    
    
    init(mainViewModel: MainViewModel) {
        self.mainViewModel = mainViewModel
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
        
        mainViewModel.yearAndMonth
            .map { "\($0.year)년 \($0.month)월" }
            .bind(to: dateLabel.rx.text)
            .disposed(by: disposeBag)
        
        downButton.rx.tap
            .bind { [weak self] in
                self?.showDatePicker()
            }
            .disposed(by: disposeBag)
        
        plusButton.rx.tap
            .subscribe(onNext: {
                let shareVM = ShareFriendViewModel()
                let VM = MakePromiseViewModel(shareFriendViewModel: shareVM)
                let VC = MakePromiseViewController(makePromiseViewModel: VM)
                self.navigationController?.pushViewController(VC, animated: true)
            })
            .disposed(by: disposeBag)
        
    }
    
    
    private func attribute(){
        view.backgroundColor = .white
        
        bellButton.do{
            $0.setImage(UIImage(named: "bell"), for: .normal)
        }
        
        [firstSeparateView,secSeparateView,thirdSeparateView]
            .forEach{ $0.backgroundColor = UIColor(named: "line") }
        
        dateLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
            
        }
        
        downButton.do{
            $0.setImage(UIImage(named: "down"), for: .normal)
        }
        
        levelLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 24*Constants.standartFont)
            $0.textColor = UIColor(hexCode: "F59564")
            $0.text = "Lv 1"
        }
        
        expLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
            $0.text = "1/10"
        }
        
        cntLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 18*Constants.standartFont)
            $0.text = "아직 약속이 없네요"
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
            $0.alignTextBelow(spacing: 40)
        }
        

        
        tableView.do{
            $0.isHidden = true
        }
        
        
    }
    
    private func layout(){
        [bellButton,dateLabel,downButton,firstSeparateView,progressView,levelLabel,expLabel,secSeparateView,cntLabel,thirdSeparateView,tableView,plusButton]
            .forEach{view.addSubview($0)}
        
        bellButton.snp.makeConstraints { make in
            make.width.height.equalTo(36*Constants.standardHeight)
            make.trailing.equalToSuperview().offset(-12*Constants.standardWidth)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(14*Constants.standardHeight)
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
        
        thirdSeparateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(cntLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        tableView.snp.makeConstraints { make in
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

        
        
        
    }
    
    func showDatePicker() {
        let alert = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 162*Constants.standardHeight))
        picker.delegate = self
        picker.dataSource = self
        alert.view.addSubview(picker)
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        let currentMonth = calendar.component(.month, from: Date()) - 1 
        if let yearIndex = years.firstIndex(of: currentYear) {
            picker.selectRow(yearIndex, inComponent: 0, animated: false)
        }
        picker.selectRow(currentMonth, inComponent: 1, animated: false)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let selectedYear = self.years[picker.selectedRow(inComponent: 0)]
            let selectedMonth = self.months[picker.selectedRow(inComponent: 1)]
            self.mainViewModel.yearAndMonth.onNext((year: selectedYear, month: selectedMonth))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    
    
}

extension MainViewController: UIPickerViewDelegate,UIPickerViewDataSource{

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



//#if DEBUG
//import SwiftUI
//struct Preview: UIViewControllerRepresentable {
//
//    // 여기 ViewController를 변경해주세요
//    func makeUIViewController(context: Context) -> UIViewController {
//        MainViewController(mainViewModel: MainViewModel())
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
//