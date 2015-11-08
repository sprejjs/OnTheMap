//
// UIColor extension copied from http://noxytrux.github.io/blog/2014/09/25/ios-uibutton-backgroundcolor-you-do-it-wrong-dot-dot-dot/
//

import UIKit
import Foundation

extension UIColor {

    class func colorWithHex(hexString: String?) -> UIColor? {

        return colorWithHex(hexString, alpha: 1.0)
    }

    class func colorWithHex(hexString: String?, alpha: CGFloat) -> UIColor? {

        if let hexString = hexString {

            let regexp = try! NSRegularExpression(pattern: "\\A#[0-9a-f]{6}\\z",
                    options: .CaseInsensitive)

            let count = regexp.numberOfMatchesInString(hexString,
                    options: .ReportProgress,
                    range: NSMakeRange(0, hexString.characters.count))

            if count != 1 {

                return nil
            }

            var rgbValue : UInt32 = 0

            let scanner = NSScanner(string: hexString)

            scanner.scanLocation = 1
            scanner.scanHexInt(&rgbValue)

            let red   = CGFloat( (rgbValue & 0xFF0000) >> 16) / 255.0
            let green = CGFloat( (rgbValue & 0xFF00) >> 8) / 255.0
            let blue  = CGFloat( (rgbValue & 0xFF) ) / 255.0

            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }

        return nil
    }
}
