//
//  BlurredGhostViewController.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/14/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class BlurredGhostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        setupBlurredView()
        
    }
    
    func setupBlurredView() {
        
        let blurView = UIVisualEffectView()
        blurView.frame = view.frame
        blurView.effect = UIBlurEffect(style: .light)
        view.addSubview(blurView)
    }
    



}
