//
//  UISuggestionTextField.swift
//  Lanyard
//
//  Created by Nicholas Cooke on 1/12/19.
//  Copyright © 2019 Nicholas Cooke. All rights reserved.
//

import UIKit

class UISuggestionTextField: UITextField {
    
    var suggestionText: String = "" {
        didSet {
            if oldValue.isEmpty {
                suggestionTextLabel.alpha = 0
                UIView.animate(withDuration: 0.2) {
                    self.suggestionTextLabel.alpha = 1
                }
            } else if suggestionText.isEmpty {
                UIView.animate(withDuration: 0.2) {
                    self.suggestionTextLabel.alpha = 0
                }
            }
            
            self.textChanged()
            
        }
    }
    
    func textChanged() {
        let userText = text ?? ""
        suggestionTextLabel.text = userText + suggestionText[suggestionText.index(suggestionText.startIndex, offsetBy: min(userText.count, suggestionText.count))...]
    }
    
    var fieldEditor : UIView { //func with no ()....computed property...setBlock
        return subviews.first!
    }
    
    
    
    var suggestionTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.clipsToBounds = true
        label.textColor = .lightGray
        return label
    }()
    
    
    init() {
        super.init(frame: .zero)
        suggestionTextLabel.font = self.font
        fieldEditor.insertSubview(suggestionTextLabel, at: 1)
    }
    
    //    private func setText(for suggestionText : String) {
    //        let userText = text ?? ""
    //        let attributedString = NSMutableAttributedString(string: userText)
    //        attributedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.clear], range: NSRange(location: 0, length: userText.count))
    //        attributedString.append(NSAttributedString(string: String(suggestionText.dropFirst(userText.count))))
    //        suggestionTextLabel.attributedText = attributedString
    //    }
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        suggestionTextLabel.frame = fieldEditor.subviews.first {
            $0.frame.width > 40
            }?.bounds ?? .zero
        suggestionTextLabel.frame.origin.y -= 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
