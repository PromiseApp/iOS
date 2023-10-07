import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class MakePromiseViewController: UIViewController {
    let disposeBag = DisposeBag()
    var makePromiseViewModel:MakePromiseViewModel
    weak var promiseCoordinator: PromiseCoordinator?
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let scrollView = UIScrollView()
    let promiseTitleLabel = UILabel()
    let promiseTitleTextField = UITextField()
    let firstConditionLabel = UILabel()
    let scheduleLabel = UILabel()
    let dateButton = UIButton()
    let timeButton = UIButton()
    let placeLabel = UILabel()
    let placeTextField = UITextField()
    let friendLabel = UILabel()
    let addFriendButton = UIButton()
    let secAddFriendButton = UIButton()
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.itemSize = CGSize(width: 45*Constants.standardWidth, height: 49*Constants.standardHeight)
        $0.minimumInteritemSpacing = 8*Constants.standardWidth
    })
    let penaltyLabel = UILabel()
    let penaltyTextView = UITextView()
    let secondConditionLabel = UILabel()
    let memoLabel = UILabel()
    let memoTextView = UITextView()
    let thirdConditionLabel = UILabel()
    let nextButton = UIButton()
    
    let years = Array(2000...2100)
    let months = Array(1...12)
    let days = Array(1...31)
    let hours = Array(0...23)
    let minutes = Array(0...59)
    
    init(makePromiseViewModel: MakePromiseViewModel, promiseCoordinator: PromiseCoordinator?) {
        self.makePromiseViewModel = makePromiseViewModel
        self.promiseCoordinator = promiseCoordinator
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
            .subscribe(onNext: { [weak self] in
                self?.promiseCoordinator?.popToVC()
            })
            .disposed(by: disposeBag)
        
        promiseTitleTextField.rx.text.orEmpty
            .bind(to: makePromiseViewModel.titleRelay)
            .disposed(by: disposeBag)
        
        dateButton.rx.tap
            .subscribe(onNext: {
                self.showDatePicker()
            })
            .disposed(by: disposeBag)
        
        makePromiseViewModel.dateRelay
            .map { "\($0.year)년 \($0.month)월 \($0.day)일" }
            .do(onNext: { [weak self] _ in
                    self?.dateButton.setTitleColor(.black, for: .normal)
                })
            .bind(to: dateButton.rx.title(for: .normal))
            .disposed(by: disposeBag)

        timeButton.rx.tap
            .subscribe(onNext: {
                self.showTimePicker()
            })
            .disposed(by: disposeBag)
        
        makePromiseViewModel.timeRelay
            .map { String(format: "%02d:%02d", $0.hour, $0.minute) }
            .do(onNext: { [weak self] _ in
                    self?.timeButton.setTitleColor(.black, for: .normal)
                })
            .bind(to: timeButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        addFriendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.promiseCoordinator?.goToSelectFriendVC()
            })
            .disposed(by: disposeBag)
        
        secAddFriendButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.promiseCoordinator?.goToSelectFriendVC()
            })
            .disposed(by: disposeBag)

        
        makePromiseViewModel.selectedFriendDatas
            .drive(onNext: { [weak self] friends in
                if friends.isEmpty{
                    self?.collectionView.isHidden = true
                    self?.addFriendButton.isHidden = false
                    self?.secAddFriendButton.isHidden = true
                }
                else{
                    self?.collectionView.isHidden = false
                    self?.addFriendButton.isHidden = true
                    self?.secAddFriendButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)

        
        makePromiseViewModel.selectedFriendDatas
            .drive(collectionView.rx.items(cellIdentifier: "FriendCollectionViewCell", cellType: FriendCollectionViewCell.self)) { row, friend, cell in
                cell.configure(with: friend)
//                cell.deleteButton.rx.tap
//                    .subscribe(onNext: { [weak self] in
//                        self?.makePromiseViewModel.toggleSelection(at: row)
//                    })
//                    .disposed(by: cell.disposeBag)
                cell.deleteButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        self?.makePromiseViewModel.toggleSelection(friend: friend)
                    })
                    .disposed(by: cell.disposeBag)

            }
            .disposed(by: disposeBag)

      
        makePromiseViewModel.isNextButtonEnabled
            .subscribe(onNext: { [weak self] bool in
                if(bool){
                    self?.nextButton.isEnabled = true
                    self?.nextButton.alpha = 1
                }
                else{
                    self?.nextButton.isEnabled = false
                    self?.nextButton.alpha = 0.3
                }
            })
            .disposed(by: disposeBag)

        
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "약속 만들기"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        promiseTitleLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "제목*"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "*"))
            
            $0.attributedText = attributedString
        }
        
        promiseTitleTextField.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.placeholder = "지인들과 술자리 / 수영장 가기 등"
            $0.addLeftPadding(width: 12*Constants.standardWidth)
        }
        
        firstConditionLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 13)
            let text = "20자까지 입력 가능해요!"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "20자"))
            
            $0.attributedText = attributedString
        }
        
        scheduleLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "일정*"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "*"))
            
            $0.attributedText = attributedString
        }
        
        dateButton.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.setTitle("YY-MM-DD", for: .normal)
            $0.setTitleColor(UIColor(named: "greyOne"), for: .normal)
        }
        
        timeButton.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.setTitle("00:00", for: .normal)
            $0.setTitleColor(UIColor(named: "greyOne"), for: .normal)
        }
        
        placeLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "장소"
        }
        
        placeTextField.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.placeholder = "장소를 입력해보세요"
            $0.addLeftPadding(width: 12*Constants.standardWidth)
        }
        
        friendLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "친구"
        }
        
        addFriendButton.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.setImage(UIImage(named: "plus"), for: .normal)
            $0.isHidden = false
        }
        
        secAddFriendButton.do{
            $0.setTitle("추가하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setImage(UIImage(named: "right"), for: .normal)
            $0.semanticContentAttribute = .forceRightToLeft
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 15*Constants.standartFont)
            $0.isHidden = true
        }
        
        collectionView.do{
            $0.showsHorizontalScrollIndicator = false
            $0.register(FriendCollectionViewCell.self, forCellWithReuseIdentifier: "FriendCollectionViewCell")
            $0.isHidden = true
        }
        
        penaltyLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "벌칙"
        }
        
        penaltyTextView.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.delegate = self
            $0.text = "벌칙을 정해보세요"
            $0.textColor = UIColor(named: "line")
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.addLeftPadding(width: 12*Constants.standardWidth)
        }
        
        secondConditionLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "약속을 지킬 수 있도록 재밌는 벌칙을 정해보세요!"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "재밌는 벌칙"))
            
            $0.attributedText = attributedString
        }
        
        memoLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "메모"
        }
        
        memoTextView.do{
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
            $0.layer.cornerRadius = 4 * Constants.standardHeight
            $0.delegate = self
            $0.text = "중요한 내용을 메모해두세요"
            $0.textColor = UIColor(named: "line")
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.addLeftPadding(width: 12*Constants.standardWidth)
        }
        
        thirdConditionLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            let text = "준비물, 계획 등 중요한 내용을 메모해두세요"
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(.foregroundColor, value: UIColor(named: "prHeavy") ?? .black, range: (text as NSString).range(of: "메모"))
            
            $0.attributedText = attributedString
        }
        
        nextButton.do{
            $0.setTitle("만들기", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.alpha = 0.3
            $0.isEnabled = false
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,scrollView,nextButton]
            .forEach{ view.addSubview($0) }
        
        [promiseTitleLabel,promiseTitleTextField,firstConditionLabel,scheduleLabel,dateButton,timeButton,placeLabel,placeTextField,friendLabel,addFriendButton,secAddFriendButton,collectionView,penaltyLabel,penaltyTextView,secondConditionLabel,memoLabel,memoTextView,thirdConditionLabel]
            .forEach{ scrollView.addSubview($0) }
        
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
        
        nextButton.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(48*Constants.standardWidth)
            make.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top)
            make.top.equalTo(separateView.snp.bottom)
        }
        
        promiseTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalToSuperview().offset(24*Constants.standardHeight)
        }
        
        promiseTitleTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(promiseTitleLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        firstConditionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(promiseTitleTextField.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        scheduleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(firstConditionLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        dateButton.snp.makeConstraints { make in
            make.width.equalTo(173.5*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(scheduleLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        timeButton.snp.makeConstraints { make in
            make.width.equalTo(173.5*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalTo(dateButton.snp.trailing).offset(4*Constants.standardWidth)
            make.top.equalTo(scheduleLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(timeButton.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        placeTextField.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(placeLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        friendLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(placeTextField.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(50*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.width.equalToSuperview()
            make.top.equalTo(friendLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        addFriendButton.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(40*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(friendLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        addFriendButton.imageView!.snp.makeConstraints { make in
            make.width.height.equalTo(32*Constants.standardHeight)
        }
        
        secAddFriendButton.snp.makeConstraints { make in
            make.width.equalTo(85*Constants.standardWidth)
            make.height.equalTo(18*Constants.standardHeight)
            make.trailing.equalTo(view.snp.trailing).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(friendLabel)
        }
        
        penaltyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(friendLabel.snp.bottom).offset(69*Constants.standardHeight)
        }
        
        penaltyTextView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(100*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(penaltyLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        secondConditionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(penaltyTextView.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        memoLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(secondConditionLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        memoTextView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(100*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(memoLabel.snp.bottom).offset(8*Constants.standardHeight)
        }
        
        thirdConditionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(memoTextView.snp.bottom).offset(4*Constants.standardHeight)
            make.bottom.equalToSuperview().offset(-50*Constants.standardHeight)
        }
        
        
    }
    
    private func showDatePicker() {
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
        let currentDay = calendar.component(.day, from: Date()) - 1
        if let yearIndex = years.firstIndex(of: currentYear) {
            picker.selectRow(yearIndex, inComponent: 0, animated: false)
        }
        picker.selectRow(currentMonth, inComponent: 1, animated: false)
        picker.selectRow(currentDay, inComponent: 2, animated: false)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            let selectedYear = self?.years[picker.selectedRow(inComponent: 0)] ?? currentYear
            let selectedMonth = self?.months[picker.selectedRow(inComponent: 1)] ?? currentMonth + 1
            let selectedDay = self?.days[picker.selectedRow(inComponent: 2)] ?? currentDay + 1
            self?.makePromiseViewModel.dateRelay.accept((year: selectedYear, month: selectedMonth, day: selectedDay))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    private func showTimePicker() {
        let alert = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        let picker = UIPickerView()
        picker.tag = 1
        picker.delegate = self
        picker.dataSource = self
        alert.view.addSubview(picker)
        
        picker.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(150*Constants.standardHeight)
        }
        
        let calendar = Calendar.current
        let currentHour = calendar.component(.hour, from: Date())
        let currentMinute = calendar.component(.minute, from: Date())
        
        picker.selectRow(currentHour, inComponent: 0, animated: false)
        picker.selectRow(currentMinute, inComponent: 1, animated: false)
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            let selectedHour = self?.hours[picker.selectedRow(inComponent: 0)] ?? currentHour
            let selectedMinute = self?.minutes[picker.selectedRow(inComponent: 1)] ?? currentMinute
            self?.makePromiseViewModel.timeRelay.accept((hour: selectedHour, minute: selectedMinute))
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }

    
}

extension MakePromiseViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor(named: "line") {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            if textView == penaltyTextView {
                textView.text = "벌칙을 정해보세요"
            } else if textView == memoTextView {
                textView.text = "중요한 내용을 메모해두세요"
            }
            textView.textColor = UIColor(named: "line")
        }
    }
}

extension MakePromiseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 0 {
            return 3
        } else {
            return 2
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            switch component {
            case 0:
                return years.count
            case 1:
                return months.count
            case 2:
                return days.count
            default:
                return 0
            }
        } else {
            switch component {
            case 0:
                return hours.count
            case 1:
                return minutes.count
            default:
                return 0
            }
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            switch component {
            case 0:
                return "\(years[row])년"
            case 1:
                return "\(months[row])월"
            case 2:
                return "\(days[row])일"
            default:
                return ""
            }
        } else {
            switch component {
            case 0:
                return "\(hours[row])시"
            case 1:
                return "\(minutes[row])분"
            default:
                return ""
            }
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
