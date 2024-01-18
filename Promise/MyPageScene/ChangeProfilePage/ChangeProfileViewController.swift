import UIKit
import PhotosUI
import Photos
import RxSwift
import RxCocoa
import Then
import SnapKit

class ChangeProfileViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var changeProfileViewModel: ChangeProfileViewModel
    let limitedViewModel: LimitedViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    lazy var userProfileButton = UIButton()
    let cameraButton = UIButton()
    let emailLabel = UILabel()
    let userEmailLabel = UILabel()
    let stackView = UIView()
    let changeNicknameButton = UIButton()
    let changePwButton = UIButton()
    let logoutButton = UIButton()
    let separateLabel = UILabel()
    let withdrawButton = UIButton()
    
    init(changeProfileViewModel: ChangeProfileViewModel, limitedViewModel: LimitedViewModel) {
        self.changeProfileViewModel = changeProfileViewModel
        self.limitedViewModel = limitedViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        attribute()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.changeProfileViewModel.loadUserData()
    }
    
    private func bind(){
        
        leftButton.rx.tap
            .bind(to: changeProfileViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        limitedViewModel.selectedPhoto
            .bind(to: changeProfileViewModel.selectedImage)
            .disposed(by: disposeBag)
        
        changeProfileViewModel.selectedImage
            .bind(to: userProfileButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        changeProfileViewModel.userImageRelay
            .bind(to: userProfileButton.rx.image(for: .normal))
            .disposed(by: disposeBag)
        
        userProfileButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.checkPhotoLibraryPermission()
            })
            .disposed(by: disposeBag)
        
        cameraButton.rx.tap
            .bind(onNext: { [weak self] in
                self?.checkPhotoLibraryPermission()
            })
            .disposed(by: disposeBag)
        
        changeProfileViewModel.emailRelay
            .bind(to: userEmailLabel.rx.text)
            .disposed(by: disposeBag)
                
        changePwButton.rx.tap
            .bind(to: changeProfileViewModel.changePwButtonTapped)
            .disposed(by: disposeBag)

        changeNicknameButton.rx.tap
            .bind(to: changeProfileViewModel.changeNicknameButtonTapped)
            .disposed(by: disposeBag)
        
        logoutButton.rx.tap
            .bind(to: changeProfileViewModel.logoutButtonTapped)
            .disposed(by: disposeBag)
        
        withdrawButton.rx.tap
            .bind(to: changeProfileViewModel.withdrawButtonTapped)
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "프로필 수정"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        userProfileButton.do{
            $0.layer.cornerRadius = 96*Constants.standardHeight / 2
            $0.sizeToFit()
            $0.clipsToBounds = true
            $0.setImage(UIImage(named: "user"), for: .normal)
        }
        
        cameraButton.do{
            $0.sizeToFit()
            $0.clipsToBounds = true
            $0.setImage(UIImage(named: "camera"), for: .normal)
        }
        
        emailLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.text = "이메일"
        }
        
        userEmailLabel.do{
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 16*Constants.standartFont)
            $0.textColor = UIColor(named: "greyOne")
        }
        
        stackView.do{
            $0.layer.cornerRadius = 8*Constants.standardHeight
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(named: "line")?.cgColor
        }
        
        changeNicknameButton.do{
            $0.setTitle("닉네임 변경", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
        }
        
        changePwButton.do{
            $0.setTitle("비밀번호 변경", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
        }
        
        logoutButton.do{
            $0.setTitle("로그아웃", for: .normal)
            $0.setTitleColor(UIColor(named: "greyOne"), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
        }
        
        separateLabel.do{
            $0.text = "|"
            $0.textColor = UIColor(named: "line")
        }
        
        withdrawButton.do{
            $0.setTitle("회원탈퇴", for: .normal)
            $0.setTitleColor(UIColor(named: "greyOne"), for: .normal)
            $0.titleLabel?.font = UIFont(name: "Pretendard-Regular", size: 13*Constants.standartFont)
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,userProfileButton,cameraButton,emailLabel,userEmailLabel,stackView,separateLabel,logoutButton,withdrawButton]
            .forEach{ view.addSubview($0) }
        
        [changeNicknameButton,changePwButton]
            .forEach{ stackView.addSubview($0) }
        
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
        
        userProfileButton.snp.makeConstraints { make in
            make.width.height.equalTo(96*Constants.standardHeight)
            make.centerX.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalTo(userProfileButton.snp.leading).offset(72*Constants.standardWidth)
            make.top.equalTo(userProfileButton.snp.top).offset(72*Constants.standardHeight)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24*Constants.standardWidth)
            make.top.equalTo(separateView.snp.bottom).offset(156*Constants.standardHeight)
        }
        
        userEmailLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-24*Constants.standardWidth)
            make.centerY.equalTo(emailLabel)
        }
        
        stackView.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalTo(96*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalTo(emailLabel.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        changeNicknameButton.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        changeNicknameButton.titleLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
        }
        
        changePwButton.snp.makeConstraints { make in
            make.width.equalTo(351*Constants.standardWidth)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        changePwButton.titleLabel?.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
        }
        
        separateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(24*Constants.standardHeight)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.trailing.equalTo(separateLabel.snp.leading).offset(-12*Constants.standardWidth)
            make.centerY.equalTo(separateLabel)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.leading.equalTo(separateLabel.snp.trailing).offset(12*Constants.standardWidth)
            make.centerY.equalTo(separateLabel)
        }
        
    }
    
    private func checkPhotoLibraryPermission() {
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized:
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        case .limited:
            self.changeProfileViewModel.goToLimitedCollectionView.accept(())
        default:
            // 권한 요청 또는 다른 처리
            break
        }
    }

}

extension ChangeProfileViewController: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard let result = results.first else { return }
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
            print("object",object)
            if let image = object as? UIImage {
                DispatchQueue.main.async {
                    self?.changeProfileViewModel.selectedImage.accept(image)
                    print("image",image)
                }
            }
        }
    }
}
