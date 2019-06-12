//
//  SettingCell.swift
//  Example
//
//  Created by Jonny Mclaughlin on 3/5/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import UIKit
import GiphyUISDK

protocol SettingCellDelegate: class {
    func settingDidChange(setting: Setting)
}

class SettingCell: UICollectionViewCell {
    static let id: String = "SettingCell"
 
    weak var delegate: SettingCellDelegate?
    
    var setting: Setting? {
        didSet {
            textLabel.text = setting?.type.title ?? ""
            segmentedControl.removeAllSegments()
            guard let items = setting?.type.cases else { return }
            for (index, setting) in items.enumerated() {
                segmentedControl.insertSegment(withTitle: setting.string, at: index, animated: false)
            }
            segmentedControl.selectedSegmentIndex = setting?.selectedIndex ?? 0
        }
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
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
        
        contentView.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: textLabel.bottomAnchor).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: textLabel.leftAnchor).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: textLabel.rightAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -SettingsViewController.sectionPadding).isActive = true
        segmentedControl.addTarget(self, action: #selector(settingChanged), for: .valueChanged)
        segmentedControl.tintColor = SettingsViewController.sectionLabelColor
        segmentedControl.layer.cornerRadius = SettingsViewController.controlCornerRadius
        segmentedControl.layer.borderWidth = SettingsViewController.controlBorderWidth
        segmentedControl.layer.borderColor = SettingsViewController.sectionLabelColor.cgColor
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: SettingsViewController.controlFont], for: .normal)
        segmentedControl.clipsToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = ""
    }
    
    @objc func settingChanged() { 
        guard let selected = setting?.type.cases[segmentedControl.selectedSegmentIndex] else { return }
        delegate?.settingDidChange(setting: selected)
    }
}
