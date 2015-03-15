//
// UIImage extension copied from http://noxytrux.github.io/blog/2014/09/25/ios-uibutton-backgroundcolor-you-do-it-wrong-dot-dot-dot/
//

import UIKit
import Foundation

extension UIImage {
    class func imageWithColor(color:UIColor?) -> UIImage! {

        let rect = CGRectMake(0.0, 0.0, 1.0, 1.0);

        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

        let context = UIGraphicsGetCurrentContext();

        if let color = color {

            color.setFill()
        }
        else {

            UIColor.whiteColor().setFill()
        }

        CGContextFillRect(context, rect);

        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return image;
    }
}
