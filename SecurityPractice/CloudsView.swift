//
//  CloudsView.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/13/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class CloudsView: UIViewController {
    
    let testBox: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.image = UIImage(named: "cloud.png")
        imageview.backgroundColor = .clear
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let cloudsView = FloatingClouds()
    var slideConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.addSubview(cloudsView)
//        NSLayoutConstraint.activate([
//            cloudsView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor),
//            cloudsView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
//            cloudsView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
//            cloudsView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor)
//            ])

        view.addSubview(testBox)
        testBox.widthAnchor.constraint(equalToConstant: 150).isActive = true
        testBox.heightAnchor.constraint(equalToConstant: 150).isActive = true
        testBox.topAnchor.constraint(equalTo: view.topAnchor, constant: 700).isActive = true
        
        slideConstraint = testBox.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        slideConstraint.isActive = true
        
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        animateBox()
    }
    
    
    func animateBox() {
        slideConstraint.constant = view.frame.width + testBox.frame.width
        UIView.animate(withDuration: 8, delay: 0, options: [.repeat, .curveLinear], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
}




class FloatingClouds: UIView {
    
    let topCloudImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.backgroundColor = .white
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let middleCloudImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.backgroundColor = .white
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    let bottomCloudImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.backgroundColor = .white
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .orange
        addSubview(topCloudImageView)
        addSubview(middleCloudImageView)
        addSubview(bottomCloudImageView)
        setupLayout()
        
    }
    
    
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            topCloudImageView.safeTopAnchor.constraint(equalTo: safeTopAnchor, constant: 15),
            topCloudImageView.widthAnchor.constraint(equalToConstant: 100),
            topCloudImageView.heightAnchor.constraint(equalToConstant: 100)
            ])
        
        NSLayoutConstraint.activate([
            middleCloudImageView.safeTopAnchor.constraint(equalTo: safeTopAnchor, constant: 150),
            middleCloudImageView.widthAnchor.constraint(equalToConstant: 100),
            middleCloudImageView.heightAnchor.constraint(equalToConstant: 100)
            ])
        
        NSLayoutConstraint.activate([
            bottomCloudImageView.safeTopAnchor.constraint(equalTo: safeTopAnchor, constant: 300),
        bottomCloudImageView.heightAnchor.constraint(equalToConstant: 100),
            bottomCloudImageView.widthAnchor.constraint(equalToConstant: 100),
            ])
        
        bottomCloudImageView.safeLeadingAnchor.constraint(equalTo: safeLeadingAnchor, constant: 0).isActive = true
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
    
}
