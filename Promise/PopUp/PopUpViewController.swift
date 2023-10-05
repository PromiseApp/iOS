import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class PopUpViewController: UIViewController {
    let disposeBag = DisposeBag()
    let popupView: InputErrorPopupView
    
    init(title: String, desc: String) {
        self.popupView = InputErrorPopupView(title: title, desc: desc)
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .clear
        self.view.addSubview(popupView)
        
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.popupView.okButton.rx.tap
          .bind { [weak self] in
            UIView.animate(withDuration: 0.3, animations: {
              self?.popupView.alpha = 0
            }) { _ in
              self?.dismiss(animated: false, completion: nil)
            }
          }
          .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
