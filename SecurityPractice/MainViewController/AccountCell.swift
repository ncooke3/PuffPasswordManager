//
//  AccountCell.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/18/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import Foundation
import UIKit

class AccountCell: SwipeTableViewCell {
    
    let cellView: TableCellContainerView = {
        let view = TableCellContainerView()
        view.backgroundColor = Color.cityLights.withAlpha(0.8)
        // 🚧 setup shadow?
        return view
    }()
    
    let cellImageView: ContainerImageView = {
        let imageview = ContainerImageView()
        imageview.backgroundColor = .white
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont(name: "SFProRounded-Medium", size: 19)
        label.textColor = .darkGray
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = UIFont(name: "SFProRounded-Medium", size: 19)
        label.textColor = .darkGray
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func sharedInit() {
        self.backgroundColor = .clear
        
        self.addSubview(cellView)
        cellView.addSubview(cellImageView)
        cellView.addSubview(usernameLabel)
        cellView.addSubview(passwordLabel)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.safeTopAnchor.constraint(equalTo: self.safeTopAnchor, constant: 5),
            cellView.safeBottomAnchor.constraint(equalTo: self.safeBottomAnchor, constant: -5),
            cellView.safeLeadingAnchor.constraint(equalTo: self.safeLeadingAnchor, constant: 10),
            cellView.safeTrailingAnchor.constraint(equalTo: self.safeTrailingAnchor, constant: -10)])
        
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cellImageView.safeLeadingAnchor.constraint(equalTo: cellView.safeLeadingAnchor, constant: 30),
            cellImageView.widthAnchor.constraint(equalToConstant: 60),
            cellImageView.heightAnchor.constraint(equalToConstant: 60)
            ])
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5),
            usernameLabel.safeLeadingAnchor.constraint(equalTo: cellImageView.safeTrailingAnchor, constant: 30)
            ])
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5),
            passwordLabel.safeLeadingAnchor.constraint(equalTo: usernameLabel.safeTrailingAnchor, constant: 30)
            ])
    }
}

class ContainerImageView: UIImageView {
    override func layoutSubviews() {
        self.setBezierPathCorners()
    }
    
    func setBezierPathCorners() {
        let roundPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height / 3)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        layer.mask = maskLayer
    }
}

class TableCellContainerView: UIView {
    
    override func layoutSubviews() {
        self.setBezierPathCorners()
    }
    
    func setBezierPathCorners() {
        let roundPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height / 3.5)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        layer.mask = maskLayer
    }
}
