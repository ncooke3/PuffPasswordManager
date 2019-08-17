//
//  LoadingCardView.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/16/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit
import Lottie

class LoadingCardView: UIView {
    
    var animationView = AnimationView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        //setupLoadingAnimation()
        self.setupCornersAndShadows()
        self.setupGradient()
    }
    
    func setupLoadingAnimation() {
        let animation = Animation.named("loading")
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        self.addSubview(animationView)
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            animationView.widthAnchor.constraint(equalTo: widthAnchor),
//            animationView.heightAnchor.constraint(equalTo: heightAnchor)
            ])
    }
    
//    override func layoutSubviews() {
//        print("LoadingCardView layoutSubviews() called!")
//        self.setupCornersAndShadows()
//        self.setupGradient()
//    }
    
    func setupCornersAndShadows() {
        self.layer.cornerRadius = 8
        self.layer.shadowColor = Color.soothingBreeze.value.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = 0.3
        self.backgroundColor = UIColor.clear
    }
    
    func setupGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.red.cgColor, UIColor.green.cgColor]
        gradient.startPoint = CGPoint(x: 1, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        gradient.locations = [0,1]
        gradient.frame = self.bounds
        gradient.cornerRadius = 8
        gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
        self.layer.addSublayer(gradient)
    }

}
