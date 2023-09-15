import UIKit

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
        
        progressLayer.strokeColor = UIColor.red.cgColor
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







class ViewController: UIViewController {

    private let progressBar = DonutProgressView()

    override func viewDidLoad() {
        super.viewDidLoad()

        progressBar.frame = CGRect(x: 20, y: 100, width: 100, height: 100) // Adjust to have a circular shape
        //progressBar.progress = 1.1
        view.addSubview(progressBar)
        
        let button = UIButton(frame: CGRect(x: 20, y: 210, width: self.view.frame.width - 40, height: 50))
        button.setTitle("Increase Progress", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(increaseProgress), for: .touchUpInside)
        
        view.addSubview(button)
    }

    @objc func increaseProgress() {
        if progressBar.progress < 1.0 {
            progressBar.progress += 0.3
        }
    }
}





//#if DEBUG
//import SwiftUI
//struct Preview: UIViewControllerRepresentable {
//
//    // 여기 ViewController를 변경해주세요
//    func makeUIViewController(context: Context) -> UIViewController {
//        ViewController()
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
