//
//  CloudsViewController.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/13/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class CloudsViewController: UIViewController {
    
    var cloudsView: CloudsView!

    override func viewDidLoad() {
        super.viewDidLoad()

        cloudsView = CloudsView(frame: view.frame)
        view.addSubview(cloudsView)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cloudsView.animateTopCloud()
        cloudsView.animateMiddleCloud()
        cloudsView.animateBottomCloud()
    }
    
    
}
