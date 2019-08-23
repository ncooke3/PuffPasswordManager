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
import UIImageColors
import LocalAuthentication

var globalMainViewController: MainViewController?

/// handles local authentication
extension MainViewController {
    
    func authenticateUser() {
        let context = LAContext()
        var error:NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            showAlertViewIfNoBiometricSensorHasBeenDetected()
            return
        }
        
        let reason = "Let's make sure you are who you say you are! 😎"
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason, reply: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        print("Authentication was successful")
                    }
                }else {
                    DispatchQueue.main.async {
                        self.showAlertWith(title: "Something went wrong... 🤔", message: "Please try again!")
                        print("Authentication was error")
                    }
                }
            })
        } else {
            self.showAlertWith(title: "Error", message: (error?.localizedDescription)!)
        }
    }
    
    
    func showAlertWith( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "Retry", style: .default) {
            (action) in
            self.authenticateUser()
        }
        alertVC.addAction(retryAction)
        
        DispatchQueue.main.async {
             self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWith(title: "Error", message: "This device does not have a FaceID/TouchID sensor.")
        
    }
}

class MainViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var backgroundView: CloudsView!
    
    var addAccountButton: AddAccountButton = {
        let button = AddAccountButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.value = "+"
        return button
    }()
    
    let tableView: UITableView = {
        let tableview = UITableView()
        tableview.separatorStyle = .none
        tableview.allowsSelection = true
        tableview.backgroundColor = .clear
        tableview.showsVerticalScrollIndicator = false
        return tableview
    }()
    
    let cellId = "cellId"
    
    // For transition to ViewController
    let transition = CircularTransition()
    
    // SwipeCellKit
    var buttonDisplayMode: ButtonDisplayMode = .imageOnly
    var buttonStyle: ButtonStyle = .circular
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.lightBackground.value
        globalMainViewController = self
        setupBackgroundView()
        setupTableView()
        setupAddAccountButton()
        setupForegroundAndBackgroundNotifications()

        // 🚧 Development Printing
        Development.printAllAccounts()
        Development.printAllCompanies()
        // 🚧 SDWebImage
//                SDImageCache.shared.clearMemory()
//                SDImageCache.shared.clearDisk(onCompletion: nil)
//        AccountDefaults.accounts.removeAll()
//        CompanyDefaults.deleteAllCompanies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        authenticateUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundView.animateTopCloud()
        backgroundView.animateMiddleCloud()
        backgroundView.animateBottomCloud()
        backgroundView.animateTitleCloud()

        if tableView.layer.mask == nil {
            let maskLayer: CAGradientLayer = CAGradientLayer()
            maskLayer.locations = [0.0, 0.01, 0.985, 1.0]
            let width = tableView.frame.size.width
            let height = tableView.frame.size.height
            maskLayer.bounds = CGRect(x: 0.0, y: 0.0, width: width, height: height)
            maskLayer.anchorPoint = CGPoint.zero

            tableView.layer.mask = maskLayer
        }

        scrollViewDidScroll(tableView)
    }
    

    
    @objc func handleAddAccountTapped() {
        let nextVC = ViewController()
        nextVC.transitioningDelegate = self
        nextVC.modalPresentationStyle = .custom
        self.present(nextVC, animated: true, completion: nil)
    }
    

    
}

/// Handles Tableview Blur on Scroll
extension MainViewController {
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
}

/// View Setup
extension MainViewController {
    
    private func setupBackgroundView() {
        backgroundView = CloudsView(frame: view.frame)
        view.insertSubview(backgroundView, at: 0)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AccountCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let topAnchorConstant = 0.30 * view.safeFrame.height
        NSLayoutConstraint.activate([
            tableView.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: topAnchorConstant),
            tableView.safeBottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.safeLeadingAnchor.constraint(equalTo: view.safeLeadingAnchor),
            tableView.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor)])
    }
    
    private func setupAddAccountButton() {
        view.addSubview(addAccountButton)
        addAccountButton.addTarget(self, action: #selector(handleAddAccountTapped), for: [.touchUpInside])
        NSLayoutConstraint.activate([
            addAccountButton.safeTopAnchor.constraint(equalTo: view.safeTopAnchor, constant: 15),
            addAccountButton.safeTrailingAnchor.constraint(equalTo: view.safeTrailingAnchor, constant: -15),
            addAccountButton.widthAnchor.constraint(equalToConstant: 50),
            addAccountButton.heightAnchor.constraint(equalToConstant: 50)
            ])
    }
}

/// Registration for Notifications
extension MainViewController {
    
    private func setupForegroundAndBackgroundNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appMovedToForeground() {
        setupBackgroundView()
        authenticateUser()
    }
    
    @objc func appMovedToBackground() {
        backgroundView.removeFromSuperview()
        backgroundView.removeConstraints(backgroundView.constraints)
    }
    
}

extension MainViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = addAccountButton.center
        transition.circleColor = addAccountButton.backgroundColor!
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = addAccountButton.center
        transition.circleColor = addAccountButton.backgroundColor!
        
        return transition
    }
    
}

/// Conforms MainViewController to UITableViewDelegate & UITableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountDefaults.accounts.count
    }
    
    fileprivate func setupLabelWithCompantLetter(_ firstLetter: String.Element, cell: AccountCell) {
        let label = UILabel()
        label.text = String(firstLetter)
        label.font = UIFont(name: "SFProRounded-Medium", size: 46)
        label.textColor = Color.soothingBreeze.value
        label.sizeToFit()
        cell.cellImageView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: cell.cellImageView.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: cell.cellImageView.centerXAnchor)
            ])
        
        label.alpha = 0
        UIView.animate(withDuration: 0.2, animations: {
            label.alpha = 1
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AccountCell
        cell.delegate = self
        
        cell.selectionStyle = .none
        
        let service = AccountDefaults.accounts[indexPath.row].service
        let company = CompanyDefaults.companies[service]

        cell.cellImageView.sd_setImage(with: company?.url) {
            (image, error, cacheType, url) in
            
            if let image = image {
                if CompanyDefaults.companies[service]?.color == nil {
                    if let colors = image.getColors() {
                        if let companyColor = colors.background {
                            let colorString = companyColor.toHexString() == "#ffffffff" ? Color.cityLights.value.toHexString() : companyColor.toHexString()
                            CompanyDefaults.companies[service]?.color = String(colorString.dropLast(2))
                        }
                        
                    }
                }
            }

            
        }
        
        cell.usernameLabel.text = AccountDefaults.accounts[indexPath.row].username

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.contentView.layer.masksToBounds = true
        let radius = cell.contentView.layer.cornerRadius
        cell.layer.shadowPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: radius).cgPath
        cell.layer.shadowColor = UIColor.clear.cgColor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedAccount = AccountDefaults.accounts[indexPath.row]
        let editAccountVC = EditAccountViewController()
        editAccountVC.selectedAccount = selectedAccount
        editAccountVC.modalPresentationStyle = .overCurrentContext

        DispatchQueue.main.async {
            self.present(editAccountVC, animated: true, completion: nil)
        }
    }
}

/// Conforms MainViewController to SwipeTableViewCellDelegate
extension MainViewController: SwipeTableViewCellDelegate  {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return [] }
    
        let delete = SwipeAction(style: .destructive, title: nil) { action, indexPath in
            let removedAccount = AccountDefaults.accounts.remove(at: indexPath.row)
            removedAccount.safelyDeleteFromKeychain()
            
            var shouldRemoveCompany = true
            AccountDefaults.accounts.forEach({ (account) in
                if account.service == removedAccount.service {
                    shouldRemoveCompany = false
                }
            })
            
            if shouldRemoveCompany {
                CompanyDefaults.companies.removeValue(forKey: removedAccount.service)
            }
            
        }
        delete.hidesWhenSelected = true
        configure(action: delete, with: .trash)
        
        return [delete]
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
        label.font = UIFont(name: "SFProRounded-Medium", size: 21)
        label.textColor = .darkGray
        label.textAlignment = .left
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
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellView.safeTopAnchor.constraint(equalTo: self.safeTopAnchor, constant: 5),
            cellView.safeBottomAnchor.constraint(equalTo: self.safeBottomAnchor, constant: -5),
            cellView.safeLeadingAnchor.constraint(equalTo: self.safeLeadingAnchor, constant: 10),
            cellView.safeTrailingAnchor.constraint(equalTo: self.safeTrailingAnchor, constant: -10)])
        
        cellImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cellImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            cellImageView.safeLeadingAnchor.constraint(equalTo: cellView.safeLeadingAnchor, constant: 50),
            cellImageView.widthAnchor.constraint(equalToConstant: 60),
            cellImageView.heightAnchor.constraint(equalToConstant: 60)
            ])
        
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: cellImageView.trailingAnchor, constant: 50)
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
