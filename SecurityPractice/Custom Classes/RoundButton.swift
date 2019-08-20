//
//  RoundButton.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 7/31/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    private var animator = UIViewPropertyAnimator()
    
    private let normalColor = Color.brightYarrow.value
    private let highlightedColor = Color.sourLemon.value
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        sharedInit()
    }
    
    func sharedInit() {
        backgroundColor = normalColor
        setContentInsets() // TODO: improve perHaps?
        addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }

    func setContentInsets() {
        self.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0)
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
        setupCornersAndShadows()
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
    
    func setupCornersAndShadows() {
        self.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 4.0
        
        //let shadowLayer = CAShapeLayer(
        
        
    }
    
}
