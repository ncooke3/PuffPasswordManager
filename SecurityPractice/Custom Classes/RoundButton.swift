//
//  RoundButton.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 7/31/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

/**
 Custom UIButton Class
 
 - seealso:
 [The Swift Standard Library Reference](https://blog.supereasyapps.com/how-to-create-round-buttons-using-ibdesignable-on-ios-11/)
 */
class RoundButton: UIButton {
    
    override var backgroundColor: UIColor? {
        didSet {
            refreshColor(color: backgroundColor ?? UIColor.gray)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    func sharedInit() {
        setContentInsets() // TODO: improve perHaps?
        refreshColor(color: backgroundColor ?? UIColor.gray)
    }

    func setContentInsets() {
        self.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
    }
    
    func createImage(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }
    
    func refreshColor(color: UIColor) {
        let image = createImage(color: color)
        setBackgroundImage(image, for: UIControl.State.normal)
        clipsToBounds = true
    }
    
    func setBezierPathCorners() {
        let roundPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        layer.mask = maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setBezierPathCorners()
    }
}
