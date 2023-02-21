//
//  ShadowView.swift
//  Prueba
//
//  Created by Jimena Reyes Reyes on 19/02/23.
//

import Foundation
import UIKit

/*@IBDesignable*/
class ShadowView: UIView{
    
    @IBInspectable
    var shadowColor:UIColor = .black{
        didSet{layer.shadowColor = shadowColor.cgColor}
    }
    
    @IBInspectable
    var shadowOpacity:Float = 0{
        didSet{layer.shadowOpacity = shadowOpacity}
    }
    
    @IBInspectable
    var shadowRadius:CGFloat = 0{
        didSet{layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable
    var shadowOffset:CGSize = .zero{
        didSet{layer.shadowOffset = shadowOffset}
    }

    @IBInspectable
    var cornerRadius:CGFloat = 0{
        didSet{
            layer.cornerRadius = cornerRadius < 0 ? bounds.height/2 : cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth:CGFloat = 1{
        didSet{layer.borderWidth = borderWidth}
    }
    
    @IBInspectable
    var borderColor:UIColor = .clear{
        didSet{layer.borderColor = borderColor.cgColor}
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = cornerRadius < 0 ? bounds.height/2 : cornerRadius
    }
}
