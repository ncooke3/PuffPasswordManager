//
//  UIViewExtension.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 7/31/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

extension UIView {
    
    static func activate(constraints: [NSLayoutConstraint]) {
        constraints.forEach {
            ($0.firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate(constraints)
    }
    
    func pin(to view: UIView, insets: UIEdgeInsets = .zero) {
        UIView.activate(constraints: [
            topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left),
            rightAnchor.constraint(equalTo: view.rightAnchor, constant: insets.right),
            bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: insets.bottom)
        ])
    }
    
    func center(in view: UIView, offset: UIOffset = .zero) {
        UIView.activate(constraints: [
            centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: offset.vertical),
            centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: offset.horizontal)
        ])
    }
    
    var safeTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return self.topAnchor
    }
    
    var safeBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return self.bottomAnchor
    }
    
    var safeTrailingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.trailingAnchor
        }
        return self.trailingAnchor
    }
    
    var safeLeadingAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *){
            return self.safeAreaLayoutGuide.leadingAnchor
        }
        return self.leadingAnchor
    }
    
    var safeCenterXAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerXAnchor
        }
        return self.centerXAnchor
    }
    
    var safeCenterYAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.centerYAnchor
        }
        return self.centerYAnchor
    }
    
    var safeFrame: CGRect {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.layoutFrame
        }
        return self.frame
    }
}
