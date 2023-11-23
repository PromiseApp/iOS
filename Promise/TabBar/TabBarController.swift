import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class TabBarController: UITabBarController {
    
    let disposeBag = DisposeBag()
    let tabBarViewModel: TabBarViewModel
    
    private var plusButton = UIButton()
    private let separateView = UIView()
    
    init(tabBarViewModel: TabBarViewModel) {
        self.tabBarViewModel = tabBarViewModel
        super.init(nibName: nil, bundle: nil)
        tabBar.backgroundColor = .white
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        bind()
        attribute()
        layout()
    }
    
    private func bind(){
        plusButton.rx.tap
            .bind(to: tabBarViewModel.plusButtonTapped)
            .disposed(by: disposeBag)
        
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
    
    private func attribute(){
        
        
        
        plusButton.do{
            $0.setImage(UIImage(named: "plus"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
    }
    
    private func layout(){
        [separateView,plusButton]
            .forEach{ self.tabBar.addSubview($0) }
        
        separateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.width.height.equalTo(48*Constants.standardHeight)
            make.centerX.equalToSuperview()
            
        }

    }
    
}

extension TabBarController: UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let viewControllers = viewControllers {
            for (index, vc) in viewControllers.enumerated() {
                if let tabItem = vc.tabBarItem {
                    if index == 1 {
                        tabItem.image = viewController == vc ? UIImage(named: "selectedChat")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "chat")?.withRenderingMode(.alwaysOriginal)
                    }
                    else if index == 3 {
                        tabItem.image = viewController == vc ? UIImage(named: "selectedFriend")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "friend")?.withRenderingMode(.alwaysOriginal)
                    }
                    else if index == 4 {
                        tabItem.image = viewController == vc ? UIImage(named: "selectedUser")?.withRenderingMode(.alwaysOriginal) : UIImage(named: "userGrey")?.withRenderingMode(.alwaysOriginal)
                    }
                }
            }
        }
    }
}
