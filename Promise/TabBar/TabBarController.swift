import UIKit
import RxSwift
import RxCocoa

class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    let disposeBag = DisposeBag()
    let tabBarViewModel: TabBarViewModel
    
    // MARK: - Initializers
    
    init(tabBarViewModel: TabBarViewModel) {
        self.tabBarViewModel = tabBarViewModel
        super.init(nibName: nil, bundle: nil)
        tabBar.backgroundColor = .white
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        

        rx.didSelect
            .map { $0.view.tag }
            .bind(to: tabBarViewModel.selectedIndex)
            .disposed(by: disposeBag)
        
        tabBarViewModel.selectedIndex
            .subscribe(onNext: { [weak self] index in
                self?.tabBar.tintColor = UIColor(named: "prHeavy")
            })
            .disposed(by: disposeBag)
        
    }
}


//#if DEBUG
//import SwiftUI
//struct Preview: UIViewControllerRepresentable {
//
//    // 여기 ViewController를 변경해주세요
//    func makeUIViewController(context: Context) -> UIViewController {
//        TabBarController(tabBarViewModel: TabBarViewModel(localizationManager: LocalizationManager.shared))
//    }
//
//    func updateUIViewController(_ uiView: UIViewController,context: Context) {
//        // leave this empty
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
