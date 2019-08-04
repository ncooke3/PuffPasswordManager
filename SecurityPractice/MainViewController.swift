//
//  MainViewController.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/3/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let tableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .none
        tableview.allowsSelection = false
        tableview.backgroundColor = .clear
        tableview.showsVerticalScrollIndicator = false
        return tableview
    }()
    
    let cellId = "cellId"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        setupTableView()
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchorConstant = 0.25 * view.safeFrame.height
        NSLayoutConstraint.activate([
            tableView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: topAnchorConstant),
            tableView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            tableView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            tableView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor)])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AccountCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // SHADOW:
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // this will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
        // if you do not set `shadowPath` you'll notice laggy scrolling
        // add this in `willDisplay` method
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        // ME: this hide the shadow color
        cell.layer.shadowColor = UIColor.clear.cgColor
    }
    
}

class AccountCell: UITableViewCell {
    
    let cellView: TableCellContainerView = {
        let view = TableCellContainerView()
        view.backgroundColor = UIColor(red: 0.69, green: 0.82, blue: 0.87, alpha: 1.0)
        // setup shadow?
        return view
    }()
    
    let cellImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .white
        imageview.contentMode = .scaleAspectFit
        return imageview
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        
        // SHADOW: add shadow on cell
        backgroundColor = .clear // very important
//        layer.masksToBounds = false
//        layer.shadowOpacity = 0.23
//        layer.shadowRadius = 4
//        layer.shadowOffset = CGSize(width: 0, height: 0)
//        layer.shadowColor = UIColor.black.cgColor

//        // add corner radius on `contentView`
        contentView.backgroundColor = .clear
//        contentView.layer.cornerRadius = 8
    }
    
    func setup() {
        addSubview(cellView)
        cellView.addSubview(cellImageView)
        cellView.addSubview(usernameLabel)
        cellView.addSubview(passwordLabel)
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.safeTopAnchor.constraint(equalTo: self.safeTopAnchor, constant: 15),
            cellView.safeBottomAnchor.constraint(equalTo: self.safeBottomAnchor, constant: -15),
            cellView.safeLeadingAnchor.constraint(equalTo: self.safeLeadingAnchor, constant: 10),
            cellView.safeTrailingAnchor.constraint(equalTo: self.safeTrailingAnchor, constant: -10)])
        
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImageView.safeTopAnchor.constraint(equalTo: cellView.safeTopAnchor, constant: 15),
            cellImageView.safeBottomAnchor.constraint(equalTo: cellView.safeBottomAnchor, constant: -15),
            cellImageView.safeLeadingAnchor.constraint(equalTo: cellView.safeLeadingAnchor, constant: 15),
            cellImageView.safeTrailingAnchor.constraint(equalTo: cellView.safeTrailingAnchor, constant: -250)
            ])
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.safeTopAnchor.constraint(equalTo: cellView.safeTopAnchor, constant: 30),
            usernameLabel.safeLeadingAnchor.constraint(equalTo: cellImageView.safeTrailingAnchor, constant: 15)
            ])
        
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordLabel.safeTopAnchor.constraint(equalTo: usernameLabel.safeBottomAnchor, constant: 20),
            passwordLabel.safeLeadingAnchor.constraint(equalTo: cellImageView.safeTrailingAnchor, constant: 15)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TableCellContainerView: UIView {
    
    override func layoutSubviews() {
        self.setBezierPathCorners()
    }
    
    func setBezierPathCorners() {
        let roundPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.bounds.height / 5)
        let maskLayer = CAShapeLayer()
        maskLayer.path = roundPath.cgPath
        layer.mask = maskLayer
    }
}

