//
//  Extensions.swift
//  Firefox Focus
//
//  Created by admin on 2020/01/15.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

// PTSans-NarrowBold
// OpenSans-Regular

extension UIApplication {
    
    var statusBar: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            
            if let statusBar = keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                guard let statusBarFrame = keyWindow?.windowScene?.statusBarManager?.statusBarFrame else { return nil }
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.tag = tag
                keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        } else {
            return nil
        }
    }
}

extension UINavigationController {
    
    open override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return visibleViewController
    }
}

extension UISearchBar {
        
    var textField : UITextField? {
        if #available(iOS 13.0, *) {
            return self.searchTextField
        } else {
            return self.value(forKey: "_searchField") as? UITextField
        }
    }
    
    func setTextColor(_ color: UIColor) {
        textField?.textColor = color
    }
    
    func setPlaceholderTextColor(_ color: UIColor) {
        textField?.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [.foregroundColor: color])
    }
    
    func setClearButtonColor(_ color: UIColor) {
        let clearButton = textField?.value(forKey: "_clearButton") as? UIButton
        clearButton?.tintColor = color
        
        if let image = clearButton?.imageView?.image {
            let editedImage = image.withRenderingMode(.alwaysTemplate)
            clearButton?.setImage(editedImage, for: .normal)
        }
    }
}

extension UIColor {
    
    static func gradientColor(colors: [CGColor], size: CGSize, startPoint: CGPoint, endPoint: CGPoint) -> UIColor {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.colors = colors
        
        UIGraphicsBeginImageContext(gradientLayer.frame.size)
        
        if let context = UIGraphicsGetCurrentContext() {
            gradientLayer.render(in: context)
        }
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            return UIColor(patternImage: image)
        }
        
        UIGraphicsEndImageContext()
        
        return .clear
    }
}
