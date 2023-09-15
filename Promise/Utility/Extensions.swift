import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12*Constants.standardWidth, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}

extension UITextView {
    func addLeftPadding() {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12*Constants.standardWidth, height: self.frame.height))
            self.addSubview(paddingView)
            
            self.textContainer.lineFragmentPadding = 12*Constants.standardWidth
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

extension UIAlertController {
    static func createAlert(title: String?, message: String?, buttonText: String, buttonBackgroundColor: UIColor, buttonTextColor: UIColor) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonText, style: .default, handler: nil)
        alert.addAction(action)
        
        // Setting button background color and text color
        alert.view.tintColor = buttonTextColor
        let subview = (alert.view.subviews.first?.subviews.first?.subviews.first!)! as UIView
        subview.backgroundColor = buttonBackgroundColor
        
        return alert
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
