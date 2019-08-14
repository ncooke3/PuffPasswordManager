//
//  CloudsView.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/14/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class CloudsView: UIView {
    
    var topCloudSlidingConstraint: NSLayoutConstraint!
    var middleCloudSlidingConstraint: NSLayoutConstraint!
    var bottomCloudSlidingConstraint: NSLayoutConstraint!
    
    let topCloudImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.image = UIImage(named: "cloud_scheme_no_bg.png")
        imageview.backgroundColor = .clear
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let middleCloudImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.image = UIImage(named: "cloud_scheme_no_bg.png")
        imageview.backgroundColor = .clear
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let bottomCloudImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.image = UIImage(named: "cloud_scheme_no_bg.png")
        imageview.backgroundColor = .clear
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = Color.darkBackground.value
        addSubview(topCloudImageView)
        addSubview(middleCloudImageView)
        addSubview(bottomCloudImageView)
        setupLayout()
        
    }
    
    func animateTopCloud() {
        self.layoutIfNeeded()
        topCloudSlidingConstraint.constant = -(self.frame.width + topCloudImageView.frame.width)
        UIView.animate(withDuration: 8, delay: 1, options: [.repeat, .curveLinear, .autoreverse], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateMiddleCloud() {
        self.layoutIfNeeded()
        middleCloudSlidingConstraint.constant = self.frame.width + middleCloudImageView.frame.width
        UIView.animate(withDuration: 8, delay: 2, options: [.repeat, .curveLinear, .autoreverse], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func animateBottomCloud() {
        self.layoutIfNeeded()
        bottomCloudSlidingConstraint.constant = self.frame.width + bottomCloudImageView.frame.width
        UIView.animate(withDuration: 6, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func setupTopCloudConstraints() {
        topCloudImageView.widthAnchor.constraint(equalToConstant: 175).isActive = true
        topCloudImageView.heightAnchor.constraint(equalToConstant: 175).isActive = true
        topCloudImageView.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
        
        topCloudSlidingConstraint = topCloudImageView.leadingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        topCloudSlidingConstraint.isActive = true
    }
    
    fileprivate func setupMiddleCloudConstraints() {
        middleCloudImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        middleCloudImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        middleCloudImageView.topAnchor.constraint(equalTo: topAnchor, constant: 300).isActive = true
        
        middleCloudSlidingConstraint = middleCloudImageView.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        middleCloudSlidingConstraint.isActive = true
    }
    
    fileprivate func setupBottomCloudConstraints() {
        bottomCloudImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        bottomCloudImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        bottomCloudImageView.topAnchor.constraint(equalTo: topAnchor, constant: 550).isActive = true
        
        bottomCloudSlidingConstraint = bottomCloudImageView.trailingAnchor.constraint(equalTo: leadingAnchor, constant: 0)
        bottomCloudSlidingConstraint.isActive = true
    }
    
    private func setupLayout() {
        
        setupTopCloudConstraints()
        setupMiddleCloudConstraints()
        setupBottomCloudConstraints()
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
}
