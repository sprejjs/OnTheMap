//
// UIImage extension copied from http://noxytrux.github.io/blog/2014/09/25/ios-uibutton-backgroundcolor-you-do-it-wrong-dot-dot-dot/
//

import UIKit
import Foundation

extension UIImage {
    class func imageWithColor(_ color:UIColor?) -> UIImage! {

        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0);

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        let context = UIGraphicsGetCurrentContext();

        if let color = color {

            color.setFill()
        }
        else {

            UIColor.white.setFill()
        }

        context?.fill(rect);

        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return image;
    }
}
