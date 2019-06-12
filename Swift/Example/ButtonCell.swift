//
//  ButtonCell.swift
//  Example
//
//  Created by Jonny Mclaughlin on 3/5/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import UIKit
import GiphyUISDK

class ButtonCell: UICollectionViewCell {
    static let id: String = "ButtonCell"
    static let backgroundColorLight: UIColor = UIColor(white: 0.95, alpha: 1.0)
    static let backgroundColorDark: UIColor = UIColor(white: 0.1, alpha: 1.0)
    
    weak var delegate: SettingsDelegate?
    
    weak var button: UIButton? {
        didSet {
            addButton()
        }
    }
    
    func addButton() {
        guard let button = button else { return }
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        button.addTarget(self, action: #selector(gifButtonTapped), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        button?.removeFromSuperview()
        button?.removeTarget(self, action: #selector(gifButtonTapped), for: .touchUpInside)
        button = nil
    }
    
    @objc func gifButtonTapped(sender: UIButton) {
        let buttonCopy = sender.copy()
        guard let button = buttonCopy as? UIButton else { return }
        delegate?.buttonDidChange(button)
    }
}

extension GPHBrandButton: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let button = GPHBrandButton()
        button.fill = fill
        button.rounded = rounded
        return button
    }
}

extension GPHGenericButton: NSCopying {
    public func copy(with zone: NSZone? = nil) -> Any {
        let button = GPHGenericButton()
        button.style = style
        button.gradient = gradient
        button.rounded = rounded
        return button
    }
    
    
}
