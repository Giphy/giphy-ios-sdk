//
//  ContentTypeSettingCell.swift
//  Example
//
//  Created by Jonny Mclaughlin on 6/6/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import UIKit
import GiphyUISDK

protocol ContentTypeSettingCellDelegate: class {
    func contentTypesDidChange(contentTypes: [GPHContentType])
}

class ContentTypeButton: UIButton {
    var contentType: GPHContentType = .gifs
}

class ContentTypeSettingCell: UICollectionViewCell {
    static let id: String = "ContentTypeSettingCell"
    
    weak var delegate: ContentTypeSettingCellDelegate?
    var isDark: Bool = false {
        didSet {
            updateSelected()
        }
    }
    var layout: GPHGridLayout = GPHGridLayout.defaultSetting {
        didSet {
            textLabel.text = "Content Type" + (layout == .waterfall ? "s" : "")
            updateButtons()
        }
    }
    
    var buttons: [ContentTypeButton] = []
    var availableContentTypes: [GPHContentType] = []
    var selectedContentTypes: [GPHContentType] = GPHContentType.defaultSetting
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let wrapperView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fillEqually
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(textLabel)
        textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textLabel.textColor = SettingsViewController.sectionLabelColor
        
        let fullWidth = textLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -SettingsViewController.sectionPadding * 2.0)
        fullWidth.priority = .defaultHigh
        fullWidth.isActive = true
        
        let maxWidth = textLabel.widthAnchor.constraint(lessThanOrEqualToConstant: SettingsViewController.sectionMaxWidth)
        maxWidth.priority = .required
        maxWidth.isActive = true
        
        contentView.addSubview(wrapperView)
        wrapperView.topAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
        wrapperView.leftAnchor.constraint(equalTo: textLabel.leftAnchor).isActive = true
        wrapperView.rightAnchor.constraint(equalTo: textLabel.rightAnchor).isActive = true
        wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SettingsViewController.sectionPadding).isActive = true
        wrapperView.layer.cornerRadius = SettingsViewController.controlCornerRadius
        wrapperView.layer.borderColor = SettingsViewController.sectionLabelColor.cgColor
        wrapperView.layer.borderWidth = SettingsViewController.controlBorderWidth
        wrapperView.backgroundColor = SettingsViewController.sectionLabelColor
        wrapperView.clipsToBounds = true
        
        wrapperView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: wrapperView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: wrapperView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: wrapperView.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor).isActive = true
        stackView.spacing = 1.0
        
        updateButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateButtons() {
        for button in buttons {
            stackView.removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        switch layout {
        case .waterfall:
            availableContentTypes = [.gifs, .stickers, .text, .emoji]
            selectedContentTypes = GPHContentType.defaultSetting
        case .carousel:
            availableContentTypes = [.gifs, .stickers, .text]
            selectedContentTypes = [.gifs]
        }
        
        buttons = []
        for type in availableContentTypes {
            let button = ContentTypeButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(SettingsViewController.sectionLabelColor, for: .normal)
            button.titleLabel?.font = SettingsViewController.controlFont
            button.contentType = type
            switch type {
            case .gifs: button.setTitle("GIFs", for: .normal)
            case .stickers: button.setTitle("Stickers", for: .normal)
            case .text: button.setTitle("Text", for: .normal)
            case .emoji: button.setTitle("Emoji", for: .normal)
            }
            buttons.append(button)
            button.addTarget(self, action: #selector(buttonSelected(button:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }
        
        updateSelected()
    }
    
    func updateSelected() {
        let activeTextColor: UIColor = isDark ? .black : .white
        for button in buttons {
            if selectedContentTypes.contains(button.contentType) {
                button.setTitleColor(activeTextColor, for: .normal)
                button.backgroundColor = SettingsViewController.sectionLabelColor
            } else {
                button.setTitleColor(SettingsViewController.sectionLabelColor, for: .normal)
                button.backgroundColor = activeTextColor
            }
        }
        delegate?.contentTypesDidChange(contentTypes: selectedContentTypes)
    }
    
    @objc func buttonSelected(button: ContentTypeButton) {
        if layout == .carousel {
            selectedContentTypes = [button.contentType]
        } else {
            if selectedContentTypes.contains(button.contentType) {
                guard selectedContentTypes.count > 1 else { return }
                selectedContentTypes = selectedContentTypes.filter({ $0 != button.contentType })
            } else {
                selectedContentTypes.append(button.contentType)
            }
        }
        updateSelected()
    }
}
