//
//  AddAccountButton.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/17/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import Foundation
import UIKit

class AddAccountButton: UIControl {
    
    public var value: String = "+" {
        didSet {
            label.text = "\(value)"
        }
    }
    
    private var label: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProRounded-Medium", size: 36)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var animator = UIViewPropertyAnimator()
    
    private let normalColor = Color.brightYarrow.value
    private let highlightedColor = Color.sourLemon.value
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    private func sharedInit() {
        backgroundColor = normalColor
        
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
        
        addSubview(label)
        let verticalScalingOffset = self.intrinsicContentSize.height * -0.06
        label.center(in: self, offset: UIOffset(horizontal: 0, vertical: verticalScalingOffset))
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setBezierPathCorners()
    }
    
    @objc private func touchDown() {
        animator.stopAnimation(true)
        backgroundColor = highlightedColor
    }
    
    @objc private func touchUp() {
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeOut, animations: {
            self.backgroundColor = self.normalColor
        })
        animator.startAnimation()
    }
    
    func setBezierPathCorners() {
        let roundPath = UIBezierPath(roundedRect: bounds, cornerRadius: bounds.height / 2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        layer.mask = maskLayer
    }
    
}
