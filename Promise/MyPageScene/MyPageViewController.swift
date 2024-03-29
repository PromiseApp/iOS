import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class MyPageViewController: UIViewController {
    let disposeBag = DisposeBag()
    var myPageViewModel: MyPageViewModel
    
    let titleLabel = UILabel()
    let separateView = UIView()
    let greyView = UIView()
    let firstView = UIView()
    let secView = UIView()
    lazy var userImageView = UIImageView()
    let nicknameLabel = UILabel()
    let emailLabel = UILabel()
    let infoSettingButton = UIButton()
    lazy var levelLabel = UILabel()
    lazy var expLabel = UILabel()
    let announcementButton = UIButton()
    let inquiryButton = UIButton()
    let tpButton = UIButton()
    let versionLabel = UILabel()
    
    init(myPageViewModel: MyPageViewModel) {
        self.myPageViewModel = myPageViewModel
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
        self.myPageViewModel.loadUserData()
    }
    
    private func bind(){
        infoSettingButton.rx.tap
            .bind(to: myPageViewModel.infoSettingButtonTapped)
            .disposed(by: disposeBag)

        announcementButton.rx.tap
            .bind(to: myPageViewModel.announcementButtonTapped)
            .disposed(by: disposeBag)
        
        inquiryButton.rx.tap
            .bind(to: myPageViewModel.inquiryButtonTapped)
            .disposed(by: disposeBag)
        
        tpButton.rx.tap
            .bind(to: myPageViewModel.tpButtonTapped)
            .disposed(by: disposeBag)
        
        myPageViewModel.emailRelay
            .bind(to: emailLabel.rx.text)
            .disposed(by: disposeBag)
        
        myPageViewModel.nicknameRelay
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        myPageViewModel.userImageRelay
            .bind(to: userImageView.rx.image)
            .disposed(by: disposeBag)
        
        myPageViewModel.levelRelay
            .subscribe(onNext: { [weak self] level in
                self?.levelLabel.text = "Lv.\(level)"
            })
            .disposed(by: disposeBag)
        
        myPageViewModel.expRelay
            .subscribe(onNext: { [weak self] exp in
                self?.expLabel.text = "다음 레벨까지 \(10-exp)개 남으셨어요:)"
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "내 정보"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        greyView.do{
            $0.backgroundColor = UIColor(named: "greyFive")
        }
        
        firstView.do{
            $0.backgroundColor = UIColor(named: "prLight")
            $0.layer.cornerRadius = 8*Constants.standardHeight
        }
        
        secView.do{
            $0.backgroundColor = UIColor.white
            $0.layer.cornerRadius = 8*Constants.standardHeight
        }
        
        userImageView.do{
            $0.layer.cornerRadius = 20*Constants.standardHeight
            $0.sizeToFit()
            $0.clipsToBounds = true
            $0.image = UIImage(named: "user")
        }
        
        nicknameLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
        }
        
        emailLabel.do{
            $0.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
        }
        
        infoSettingButton.do{
            var configuration = UIButton.Configuration.plain()
            configuration.attributedTitle = AttributedString("정보 수정하기", attributes: AttributeContainer([NSAttributedString.Key.font : UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)!]))
            configuration.image = UIImage(named: "setting")?.withRenderingMode(.alwaysTemplate)
            configuration.imagePlacement = .leading
            configuration.imagePadding = 4*Constants.standardWidth
            $0.configuration = configuration
            $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 11*Constants.standartFont)
            $0.setTitleColor(UIColor(named: "greyTwo"), for: .normal)
            $0.tintColor = UIColor(named: "greyTwo")
        }
        
        levelLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.textColor = UIColor(named: "prHeavy")
        }
        
        expLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 14*Constants.standartFont)
        }
        
        announcementButton.do{
            $0.setTitle("공지사항", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.contentHorizontalAlignment = .leading
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12*Constants.standardWidth, bottom: 0, right: 0)
        }
        
        inquiryButton.do{
            $0.setTitle("1:1 문의하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.contentHorizontalAlignment = .leading
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12*Constants.standardWidth, bottom: 0, right: 0)
        }
        
        tpButton.do{
            $0.setTitle("약관 및 정책", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.contentHorizontalAlignment = .leading
            $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12*Constants.standardWidth, bottom: 0, right: 0)
        }
        
        versionLabel.do{
            $0.text = "ver 1.5"
            $0.textColor = UIColor(named: "greyOne")
        }
        
    }
    
    private func layout(){
        [titleLabel,separateView,greyView,firstView,secView,userImageView,nicknameLabel,emailLabel,infoSettingButton,levelLabel,expLabel,announcementButton,inquiryButton,tpButton,versionLabel]
            .forEach{ view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(56*Constants.standardHeight)
        }
        
        separateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        greyView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(205*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom)
        }
        
        firstView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(76*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(greyView.snp.top).offset(24*Constants.standardHeight)
        }
        
        userImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40*Constants.standardWidth)
            make.leading.equalTo(firstView.snp.leading).offset(24*Constants.standardWidth)
            make.centerY.equalTo(firstView)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(8*Constants.standardWidth)
            make.top.equalTo(userImageView.snp.top)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalTo(userImageView.snp.trailing).offset(8*Constants.standardWidth)
            make.top.equalTo(nicknameLabel.snp.bottom).offset(4*Constants.standardHeight)
        }
        
        infoSettingButton.snp.makeConstraints { make in
            make.width.equalTo(76*Constants.standardWidth)
            make.height.equalTo(13*Constants.standardHeight)
            make.trailing.equalTo(firstView.snp.trailing).offset(-12*Constants.standardWidth)
            make.top.equalTo(firstView.snp.top).offset(8*Constants.standardHeight)
        }
        
        infoSettingButton.imageView?.snp.makeConstraints { make in
            make.width.height.equalTo(12*Constants.standardHeight)
        }
        
        infoSettingButton.titleLabel?.snp.makeConstraints{ make in
            make.trailing.equalToSuperview()
        }
        
        secView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(48*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(firstView.snp.bottom).offset(33*Constants.standardHeight)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(81*Constants.standardWidth)
            make.centerY.equalTo(secView)
        }
        
        expLabel.snp.makeConstraints { make in
            make.leading.equalTo(levelLabel.snp.trailing).offset(8*Constants.standardWidth)
            make.centerY.equalTo(secView)
        }
        
        announcementButton.snp.makeConstraints { make in
            make.height.equalTo(48*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(greyView.snp.bottom).offset(32*Constants.standardHeight)
        }
        
        inquiryButton.snp.makeConstraints { make in
            make.height.equalTo(48*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(announcementButton.snp.bottom)
        }
        
        tpButton.snp.makeConstraints { make in
            make.height.equalTo(48*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(inquiryButton.snp.bottom)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(tpButton.snp.bottom).offset(32*Constants.standardHeight)
        }
        
    }
    


}
