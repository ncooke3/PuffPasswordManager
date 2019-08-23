//
//  CloudsView.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/14/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

let cloudImage = "cloud.png"
let cloudTitleImage = "cloud_with_title.png"

class CloudsView: UIView {
    
    var titleCloudSlidingConstraint: NSLayoutConstraint!
    var topCloudSlidingConstraint: NSLayoutConstraint!
    var middleCloudSlidingConstraint: NSLayoutConstraint!
    var bottomCloudSlidingConstraint: NSLayoutConstraint!
    
    let titleCloudImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.image = UIImage(named: cloudTitleImage)
        imageview.backgroundColor = .clear
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let topCloudImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.image = UIImage(named: cloudImage)
        imageview.backgroundColor = .clear
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let middleCloudImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.image = UIImage(named: cloudImage)
        imageview.backgroundColor = .clear
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let bottomCloudImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.image = UIImage(named: cloudImage)
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
        backgroundColor = Color.electronBlue.value
        addSubview(topCloudImageView)
        addSubview(middleCloudImageView)
        addSubview(bottomCloudImageView)
        addSubview(titleCloudImageView)        
        setupLayout()
        
    }
    
    public func animateTopCloud() {
        self.layoutIfNeeded()
        topCloudSlidingConstraint.constant = -(self.frame.width + topCloudImageView.frame.width)
        UIView.animate(withDuration: 16, delay: 1, options: [.repeat, .curveLinear, .autoreverse], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    public func animateMiddleCloud() {
        self.layoutIfNeeded()
        middleCloudSlidingConstraint.constant = self.frame.width + middleCloudImageView.frame.width
        UIView.animate(withDuration: 12, delay: 2, options: [.repeat, .curveLinear, .autoreverse], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    public func animateBottomCloud() {
        self.layoutIfNeeded()
        bottomCloudSlidingConstraint.constant = self.frame.width + bottomCloudImageView.frame.width
        UIView.animate(withDuration: 10, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    public func animateTitleCloud() {
        self.layoutIfNeeded()
        titleCloudSlidingConstraint.constant = 0.049 * self.frame.height
        UIView.animate(withDuration: 3, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func setupTopCloudConstraints() {
        print("Framey", self.frame)
        topCloudImageView.widthAnchor.constraint(equalToConstant: 0.215 * self.frame.height).isActive = true
        topCloudImageView.heightAnchor.constraint(equalToConstant: 0.215 * self.frame.height).isActive = true
        topCloudImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0.036 * self.frame.height).isActive = true
        
        topCloudSlidingConstraint = topCloudImageView.leadingAnchor.constraint(equalTo: trailingAnchor)
        topCloudSlidingConstraint.isActive = true
    }
    
    private func setupMiddleCloudConstraints() {
        middleCloudImageView.widthAnchor.constraint(equalToConstant: 0.246 * self.frame.height).isActive = true
        middleCloudImageView.heightAnchor.constraint(equalToConstant: 0.246 * self.frame.height).isActive = true
        middleCloudImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0.369 * self.frame.height).isActive = true
        
        middleCloudSlidingConstraint = middleCloudImageView.trailingAnchor.constraint(equalTo: leadingAnchor)
        middleCloudSlidingConstraint.isActive = true
    }
    
    private func setupBottomCloudConstraints() {
        bottomCloudImageView.widthAnchor.constraint(equalToConstant: 0.184 * self.frame.height).isActive = true
        bottomCloudImageView.heightAnchor.constraint(equalToConstant: 0.184 * self.frame.height).isActive = true
        bottomCloudImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0.677 * self.frame.height).isActive = true
        
        bottomCloudSlidingConstraint = bottomCloudImageView.trailingAnchor.constraint(equalTo: leadingAnchor)
        bottomCloudSlidingConstraint.isActive = true
    }
    
    private func setupTitleCloudConstraints() {
        titleCloudImageView.widthAnchor.constraint(equalToConstant: 0.369 * self.frame.height).isActive = true
        titleCloudImageView.heightAnchor.constraint(equalToConstant: 0.369 * self.frame.height).isActive = true
        titleCloudImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        titleCloudSlidingConstraint = titleCloudImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0.055 * self.frame.height)
        titleCloudSlidingConstraint.isActive = true
    }
    
    private func setupLayout() {
        setupTopCloudConstraints()
        setupMiddleCloudConstraints()
        setupBottomCloudConstraints()
        setupTitleCloudConstraints()
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
}
