//
//  ButtonCell.swift
//  Example
//
//  Created by Jonny Mclaughlin on 3/5/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import UIKit
import GiphyUISDK

protocol ButtonCellDelegate: class {
    func buttonDidChange(button: UIButton)
}

class ButtonCell: UICollectionViewCell {
    static let id: String = "ButtonCell"
    static let backgroundColorLight: UIColor = UIColor(white: 0.95, alpha: 1.0)
    static let backgroundColorDark: UIColor = UIColor(white: 0.1, alpha: 1.0)
    
    weak var delegate: ButtonCellDelegate?
    var button: UIButton? {
        didSet {
            addButton()
        }
    }
    
    func addButton() {
        guard let button = button else { return }
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        button.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        button.addTarget(self, action: #selector(gifButtonTapped), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        button?.removeFromSuperview()
        button = nil
    }
    
    @objc func gifButtonTapped(sender: UIButton) {
        let buttonCopy = sender.copy()
        guard let button = buttonCopy as? UIButton else { return }
        delegate?.buttonDidChange(button: button)
    }
}

extension GPHGiphyButton: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let button = GPHGiphyButton()
        button.style = style
        return button
    }
}

extension GPHGifButton: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let button = GPHGifButton()
        button.style = style
        button.color = color
        return button
    }
}

extension GPHContentTypeButton: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let button = GPHContentTypeButton()
        button.style = style
        button.color = color
        return button
    }
}
