import UIKit
import Kingfisher
import RxSwift

class DonutProgressView: UIView {
    
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    
    var progress: CGFloat = 0 {
        didSet {
            progress = min(max(progress, 0), 1)
            updatePath()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundLayer.strokeColor = UIColor.gray.cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 23 * Constants.standardHeight
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)
        
        progressLayer.strokeColor = UIColor(hexCode: "#F59564").cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 23 * Constants.standardHeight
        progressLayer.lineCap = .round
        layer.addSublayer(progressLayer)
        
        updatePath()
    }
    
    
    private func updatePath() {
        let startAngle = deg2rad(120)
        let endAngle = deg2rad(420)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - progressLayer.lineWidth / 2
        
        let backgroundPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        backgroundLayer.path = backgroundPath.cgPath
        
        let progressEndAngle = startAngle + (endAngle - startAngle) * progress
        let progressPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: progressEndAngle, clockwise: true)
        progressLayer.path = progressPath.cgPath
    }
    
    private func deg2rad(_ degree: CGFloat) -> CGFloat {
        return degree * .pi / 180
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePath()
    }
}

extension UITextField {
    func addLeftPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}

extension UITextView {
    func addLeftPadding(width: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.frame.height))
        self.addSubview(paddingView)
        self.textContainer.lineFragmentPadding = width
    }
}

extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
}

extension UIButton {
    func alignTextBelow(spacing: CGFloat) {
        guard let image = self.imageView?.image else {
            return
        }
        
        guard let titleLabel = self.titleLabel else {
            return
        }
        
        guard let titleText = titleLabel.text else {
            return
        }
        
        let titleSize = titleText.size(withAttributes: [
            NSAttributedString.Key.font: titleLabel.font as Any
        ])
        
        titleEdgeInsets = UIEdgeInsets(top: spacing, left: -image.size.width, bottom: image.size.height+spacing, right: 0)
        imageEdgeInsets = UIEdgeInsets(top: (titleSize.height + spacing), left: 0, bottom: 0, right: -titleSize.width)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround(disposeBag: DisposeBag) {
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.bind { [unowned self] _ in
            self.view.endEditing(true)
        }.disposed(by: disposeBag)
    }
}

extension Reactive where Base == KingfisherManager {
    func retrieveImage(with url: URL) -> Single<UIImage?> {
        return Single<UIImage?>.create { single in
            let task = KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { result in
                switch result {
                case .success(let imageResult):
                    single(.success(imageResult.image))
                case .failure(let error):
                    single(.failure(error))
                }
            }
            return Disposables.create {
                task?.cancel()
            }
        }
    }
}

