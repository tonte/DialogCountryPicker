import Foundation
import UIKit
extension UIFont {
    static func regular(size: Int = 16) -> UIFont {
        return self.baseFontAction(name: "WorkSans-Regular.ttf", size: size)
    }

    static func medium(size: Int = 16) -> UIFont {
        return self.baseFontAction(name: "WorkSans-Medium", size: size)
    }

    static func bold(size: Int = 16) -> UIFont {
        return self.baseFontAction(name: "WorkSans-Bold.ttf", size: size)
    }

    static func baseFontAction(name: String,size: Int) -> UIFont {
        guard let customFont = UIFont(name: name, size: CGFloat(size)) else {
            return UIFont.systemFont(ofSize: CGFloat(size))
        }
        return UIFontMetrics.default.scaledFont(for: customFont)
    }
}
