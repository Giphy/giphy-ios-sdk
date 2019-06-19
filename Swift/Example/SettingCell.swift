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
            segmentedControl.removeAllSegments()
            segmentedControl.selectedSegmentIndex = 0
            guard let items = setting?.cases else { return }
            for (index, item) in items.enumerated() {
                guard let item = item as? Setting else { return }
                segmentedControl.insertSegment(withTitle: item.string, at: index, animated: false)
                if item.string == self.setting?.string {
                    segmentedControl.selectedSegmentIndex = index
                }
            }
        }
    }
    
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(segmentedControl)
        segmentedControl.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        segmentedControl.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        segmentedControl.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        segmentedControl.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
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
        setting = nil
    }
    
    @objc func settingChanged() { 
        guard let selected = setting?.cases[segmentedControl.selectedSegmentIndex] as? Setting else { return }
        delegate?.settingDidChange(setting: selected)
    }
}
