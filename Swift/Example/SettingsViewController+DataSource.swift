//
//  SettingsViewController+DataSource.swift
//  Example
//
//  Created by Jonny Mclaughlin on 3/7/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//


import UIKit
import GiphyUISDK

enum ButtonItems: Int {
    case branded
    case generic
    case genericRounded
    static let count = 3
    
    var itemCount: Int {
        switch self {
        case .branded: return 3
        case .generic, .genericRounded: return 9
        }
    }
}

extension SettingsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return ButtonItems.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return settings.count }
        if section == 1 { return 1 }
        guard let item = ButtonItems(rawValue: section - 1) else { return 0 }
        return item.itemCount
    }
    
    
    func settingCellForIndexPath( _ indexPath: IndexPath) -> UICollectionViewCell {
        let genericCell = collectionView.dequeueReusableCell(withReuseIdentifier: SettingCell.id, for: indexPath)
        guard let cell = genericCell as? SettingCell else { return genericCell }
        let settable = settings[indexPath.item]
        cell.setting = settable
        cell.delegate = self
        return cell
    }
    
    func layoutDidUpdate() {
        let indexPath = IndexPath(row: 0, section: 1)
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 { return settingCellForIndexPath(indexPath) }
        if indexPath.section == 1 {
            let genericCell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentTypeSettingCell.id, for: indexPath)
            guard let cell = genericCell as? ContentTypeSettingCell else { return genericCell }
            cell.layout = self.layout
            cell.isDark = self.theme == .dark
            cell.delegate = self
            return cell
        }
        let genericCell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCell.id, for: indexPath)
        guard let cell = genericCell as? ButtonCell, let buttonItem = ButtonItems(rawValue: indexPath.section - 1) else { return genericCell }
        cell.backgroundColor = theme == .dark ? ButtonCell.backgroundColorDark : ButtonCell.backgroundColorLight
        cell.delegate = self.delegate
        
        switch buttonItem {
        case .branded:
            let button = GPHBrandButton()
            button.fill = brandButtonFills[indexPath.item % brandButtonFills.count]
            button.rounded = indexPath.item == 1
            cell.button = button
            return cell
        case .generic, .genericRounded:
            let button = GPHGenericButton()
            button.style = genericButtonStyles[indexPath.item % genericButtonStyles.count]
            button.gradient = genericButtonGradients[Int(floor(Double(indexPath.item / genericButtonGradients.count)))]
            button.rounded = buttonItem == .genericRounded
            cell.button = button
            return cell
        }
    }
}

extension SettingsViewController: SettingCellDelegate {
    func settingDidChange(setting: Setting) {
        switch setting {
        case is GPHTheme:
            guard let theme = setting as? GPHTheme else { return }
            self.theme = theme
            delegate?.themeDidChange(theme) 
            view.backgroundColor = theme == .dark ? .black : .white
            collectionView.reloadData()
        case is GPHGridLayout:
            guard let layout = setting as? GPHGridLayout else { return }
            self.layout = layout
            self.layoutDidUpdate()
        case is ConfirmationScreenSetting:
            guard let confirmationScreen = setting as? ConfirmationScreenSetting else { return }
            self.confirmationScreen = confirmationScreen
        default: break
        }
    }
}

extension SettingsViewController: ContentTypeSettingCellDelegate {
    func contentTypesDidChange(contentTypes: [GPHContentType]) {
        self.mediaTypeConfig = contentTypes
    }
}

// button styles
extension SettingsViewController {
    var brandButtonFills: [GPHBrandButtonFill] {
        return [.color, .color, self.theme == .dark ? .white : .black]
    }
    
    var genericButtonStyles: [GPHGenericButtonStyle] { return [.color, .white, .outline] }
    
    var genericButtonGradients: [GPHGenericButtonGradient] {
        return [.blue, .pink, theme == .dark ? .white : .black]
    }
}
