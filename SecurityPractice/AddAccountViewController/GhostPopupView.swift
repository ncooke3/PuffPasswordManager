//
//  GhostPopupView.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/15/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class GhostPopupView: UIView {
    
    let popupView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.image = UIImage(named: "white_ghost.png")
        imageview.backgroundColor = .clear
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    var popupViewYConstraint = NSLayoutConstraint()
    
    let popupLabel: UILabel = {
        let label = UILabel()
        label.text = "Boo! Fill out all the fields!"
        label.font = UIFont(name: "SFProRounded-Medium", size: 23)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        
        self.addSubview(popupView)
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            popupView.widthAnchor.constraint(equalToConstant: self.frame.width * 0.66), // ❓
            popupView.heightAnchor.constraint(equalToConstant: self.frame.width * 0.66) // ❓
            ])
        
        popupViewYConstraint = popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
        popupViewYConstraint.isActive = true
        
        self.addSubview(popupLabel)
        NSLayoutConstraint.activate([
            popupLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            popupLabel.topAnchor.constraint(equalTo: popupView.bottomAnchor, constant: 30)
            ])
    }
    
    func animateGhostHover() {
        self.layoutIfNeeded()
        popupViewYConstraint.constant = -10
        UIView.animate(withDuration: 0.75, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }

}
