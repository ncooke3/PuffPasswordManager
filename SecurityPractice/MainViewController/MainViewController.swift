//
//  MainViewController.swift
//  SecurityPractice
//
//  Created by Nicholas Cooke on 8/3/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit
import SwipeCellKit
import SDWebImage

class MainViewController: UIViewController {
    
    var buttonDisplayMode: ButtonDisplayMode = .imageOnly
    var buttonStyle: ButtonStyle = .circular
    
    var backgroundView: CloudsView!
    
    private lazy var addAccountButton: AddAccountButton = {
        let button = AddAccountButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.value = "+"
        return button
    }()
    
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
        
        backgroundView = CloudsView(frame: view.frame)
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
        
        // 🚧 SDWebImage
//        SDImageCache.shared.clearMemory()
//        SDImageCache.shared.clearDisk(onCompletion: nil)
        
        setupTableView()
        
        // 🚧 Development Printing
        Development.printAllAccounts()
        Development.printAllCompanies()
        
        
        view.addSubview(addAccountButton)
        NSLayoutConstraint.activate([
            addAccountButton.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: 15),
            addAccountButton.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -15),
            addAccountButton.widthAnchor.constraint(equalToConstant: 50),
            addAccountButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        //addAccountButton.center(in: view)
        
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToBackground() {
        print("App moved to background!")
    }
    
    @objc func appMovedToForeground() {
        print("App moved to foreground!")
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundView.animateTopCloud()
        backgroundView.animateMiddleCloud()
        backgroundView.animateBottomCloud()
        
        backgroundView.animateTitleCloud()

        if tableView.layer.mask == nil {

            //If you are using auto layout
            view.layoutIfNeeded()

            let maskLayer: CAGradientLayer = CAGradientLayer()

            maskLayer.locations = [0.0, 0.05, 0.95, 1.0]
            let width = tableView.frame.size.width
            let height = tableView.frame.size.height
            maskLayer.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)
            maskLayer.anchorPoint = CGPoint.zero

            tableView.layer.mask = maskLayer
        }

        scrollViewDidScroll(tableView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let outerColor = UIColor(white: 1.0, alpha: 0.0).cgColor
        let innerColor = UIColor(white: 1.0, alpha: 1.0).cgColor

        var colors = [CGColor]()

        if scrollView.contentOffset.y + scrollView.contentInset.top <= 0 {
            colors = [innerColor, innerColor, innerColor, outerColor]
        } else if scrollView.contentOffset.y + scrollView.frame.size.height >= scrollView.contentSize.height {
            colors = [outerColor, innerColor, innerColor, innerColor]
        } else {
            colors = [outerColor, innerColor, innerColor, outerColor]
        }

        if let mask = scrollView.layer.mask as? CAGradientLayer {
            mask.colors = colors

            CATransaction.begin()
            CATransaction.setDisableActions(true)
            mask.position = CGPoint(x: 0.0, y: scrollView.contentOffset.y)
            CATransaction.commit()
        }

    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchorConstant = 0.30 * view.safeFrame.height
        NSLayoutConstraint.activate([
            tableView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: topAnchorConstant),
            tableView.safeBottomAnchor.constraint(equalTo: view.safeBottomAnchor),
            tableView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            tableView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor)])
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountDefaults.accounts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AccountCell
        cell.delegate = self
        
        let service = AccountDefaults.accounts[indexPath.row].service
        let company = CompanyDefaults.companies[service]
        cell.cellImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        cell.cellImageView.sd_imageIndicator = SDWebImageProgressIndicator.`default`
        cell.cellImageView.sd_setImage(with: company?.url, completed: nil)
        
        cell.usernameLabel.text = AccountDefaults.accounts[indexPath.row].username
        cell.passwordLabel.text = AccountDefaults.accounts[indexPath.row].getPasswordFromStore()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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

extension MainViewController: SwipeTableViewCellDelegate  {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return [] }
        
        let flag = SwipeAction(style: .default, title: nil, handler: nil)
        flag.hidesWhenSelected = true
        configure(action: flag, with: .flag)
        
        let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            let removedAccount = AccountDefaults.accounts.remove(at: indexPath.row)
            removedAccount.safelyDeleteFromKeychain()

        }
        configure(action: delete, with: .trash)
        
        return [delete, flag]
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = orientation == .left ? .selection : .destructive
        options.transitionStyle = .reveal
        
        switch buttonStyle {
        case .backgroundColor:
            options.buttonSpacing = 11
        case .circular:
            options.buttonSpacing = 4
            options.backgroundColor = .clear
        }
        
        return options
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title(forDisplayMode: buttonDisplayMode)
        action.image = descriptor.image(forStyle: buttonStyle, displayMode: buttonDisplayMode)
        
        switch buttonStyle {
        case .backgroundColor:
            action.backgroundColor = descriptor.color
        case .circular:
            action.backgroundColor = .clear
            action.textColor = descriptor.color
            action.font = .systemFont(ofSize: 13)
            action.transitionDelegate = ScaleTransition.default
        }
    }

}

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
            cellView.safeTopAnchor.constraint(equalTo: self.safeTopAnchor, constant: 5),
            cellView.safeBottomAnchor.constraint(equalTo: self.safeBottomAnchor, constant: -5),
            cellView.safeLeadingAnchor.constraint(equalTo: self.safeLeadingAnchor, constant: 10),
            cellView.safeTrailingAnchor.constraint(equalTo: self.safeTrailingAnchor, constant: -10)])
        
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -5),
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
