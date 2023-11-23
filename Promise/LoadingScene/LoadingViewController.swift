import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RealmSwift

class LoadingViewController: UIViewController {
    let disposeBag = DisposeBag()
    var loadingViewModel: LoadingViewModel
    
    let weMeetImageView = UIImageView()
    
    init(loadingViewModel: LoadingViewModel) {
        self.loadingViewModel = loadingViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weMeetImageView.do{
            $0.image = UIImage(named: "weMeet")
        }
        
        weMeetImageView.snp.makeConstraints { make in
            make.width.equalTo(172*Constants.standardWidth)
            make.height.equalTo(85*Constants.standardHeight)
            make.center.equalToSuperview()
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

