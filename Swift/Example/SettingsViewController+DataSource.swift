//
//  SettingsViewController+DataSource.swift
//  Example
//
//  Created by Jonny Mclaughlin on 3/7/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//


import UIKit
import GiphyUISDK

extension SettingsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings[section].type.itemCount
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let genericCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCell.id, for: indexPath)
            guard let cell = genericCell as? HeaderCell else { return genericCell }
            cell.title = settings[indexPath.section].type.title
            return cell
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: kind, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = settings[indexPath.section]
        let genericCell = collectionView.dequeueReusableCell(withReuseIdentifier: section.type.cellId, for: indexPath)
        let item = settings[indexPath.section]
        switch genericCell {
        case let cell as SettingCell:
            cell.setting = item
            cell.delegate = self
            return cell
        case let cell as ContentTypeSettingCell:
            cell.setting = item as? ContentTypeSetting
            cell.isDark = self.theme == GPHThemeType.dark
            cell.delegate = self
            return cell
        default:
            return genericCell
        }
    }
}

extension SettingsViewController: SettingCellDelegate {
    func settingDidChange(setting: Setting) {
        switch setting {
        case is GPHThemeType:
            guard let theme = setting as? GPHThemeType else { return }
            self.theme = theme
            delegate?.themeDidChange(theme)
            view.backgroundColor = theme == GPHThemeType.dark ? .black : .white
            collectionView.reloadData()
        case is GPHGridLayout:
            guard let layout = setting as? GPHGridLayout else { return }
            self.layout = layout
            self.contentTypeSetting = layout == .carousel ? .single : .multiple
            collectionView.reloadData()
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
 
