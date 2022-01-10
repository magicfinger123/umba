//
//  Custom.swift
//  Umba
//
//  Created by CWG Mobile Dev on 07/01/2022.
//

import Foundation
import UIKit

@IBDesignable class DesignableView: UIView {

    @IBInspectable var topCornerRadius: CGFloat = 0{
         didSet{
            self.layer.cornerRadius = topCornerRadius
             self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
         }
    }
    @IBInspectable var bottomCornerRadius: CGFloat = 0{
         didSet{
            self.layer.cornerRadius = bottomCornerRadius
         self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
             
         }
     }
    @IBInspectable var bottomLeft: CGFloat = 0{
          didSet{
             self.layer.cornerRadius = bottomLeft
          self.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMinYCorner, .layerMaxXMinYCorner]
              
          }
      }
    @IBInspectable var bordercolor: UIColor = UIColor.white{
           didSet{
            self.layer.borderColor = bordercolor.cgColor
               
           }
       }
    @IBInspectable var borderwidth: CGFloat = 0{
             didSet{
                 self.layer.borderWidth = borderwidth
                 
             }
         }

}
extension UIImageView {
  func setImageColor(color: UIColor) {
    let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
    self.image = templateImage
    self.tintColor = color
  }
}
@IBDesignable class LabelDesign: UITextField {
    @IBInspectable var fontAndSize: String = "Sk-Modernist-Bold,14"{
            didSet{
               let c = fontAndSize.components(separatedBy: ",")
               let ly = CGFloat(Double(c[1])!)
                self.font = UIFont(name: c[0], size: ly)
                
            }
        }
}
@IBDesignable class CustomLabel: UILabel {
   @IBInspectable var fontAndSize: String = "Sk-Modernist-Bold,14"{
         didSet{
            let c = fontAndSize.components(separatedBy: ",")
            let ly = CGFloat(Double(c[1])!)
             self.font = UIFont(name: c[0], size: ly)
             
         }
     }
}
extension String {
    // formatting text for currency textField
    func currencyFormatting() -> String {
        if let value = Double(self) {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            if let str = formatter.string(for: value) {
                return str
            }
        }
        return ""
    }
}
@IBDesignable
public class BtnGradient: UIButton {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updatePoints()
        updateLocations()
        updateColors()
    }
}

extension UIView {
    @IBInspectable
    var cornerRadius : CGFloat {
        get{
          return self.layer.cornerRadius
        }
        set(newValue) {
            self.layer.cornerRadius = newValue
        }
    }
}
