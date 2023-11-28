import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RealmSwift

class LoadingViewController: UIViewController {
    let disposeBag = DisposeBag()
    var loadingViewModel: LoadingViewModel
    
    let plaMeetImageView = UIImageView()
    
    init(loadingViewModel: LoadingViewModel) {
        self.loadingViewModel = loadingViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        plaMeetImageView.do{
            $0.image = UIImage(named: "plaMeet")
        }
        
        view.addSubview(plaMeetImageView)
        
        plaMeetImageView.snp.makeConstraints { make in
            make.width.equalTo(172*Constants.standardWidth)
            make.height.equalTo(55*Constants.standardHeight)
            make.centerX.centerY.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.loadingViewModel.autoLogin()
        }
        
    }
    
    
    

}

//#if DEBUG
//import SwiftUI
//struct Preview: UIViewControllerRepresentable {
//
//    // 여기 ViewController를 변경해주세요
//    func makeUIViewController(context: Context) -> UIViewController {
//        LoginViewController(loginViewModel: LoginViewModel())
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

