//
//  ButtonsViewController.swift
//  Example
//
//  Created by Jonny Mclaughlin on 3/5/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import UIKit
import GiphyUISDK

protocol SettingsDelegate: class {
    func buttonDidChange(_ button: UIButton)
    func themeDidChange(_ theme: GPHTheme)
}

class SettingsViewController: UIViewController {
    static let sectionPadding: CGFloat = 20
    static let sectionLabelColor: UIColor = UIColor(white: 0.5, alpha: 1.0)
    static let sectionMaxWidth: CGFloat = 500.0
    static let controlCornerRadius: CGFloat = 5.0
    static let controlBorderWidth: CGFloat = 1.0
    static let controlFont: UIFont = .systemFont(ofSize: 13, weight: .regular)
    
    var layout: GPHGridLayout = GPHGridLayout.defaultSetting
    var theme: GPHTheme = GPHTheme.defaultSetting
    var confirmationScreen: ConfirmationScreenSetting = ConfirmationScreenSetting.defaultSetting
    var mediaTypeConfig: [GPHContentType] = GPHContentType.defaultSetting

    var settings: [Setting] { return [theme, layout, confirmationScreen] }
    
    weak var delegate: SettingsDelegate?
    
    let closeButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "CloseButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = theme == .dark ? .black : .white
        
        view.addSubview(closeButton)
        closeButton.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -10).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 10).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        
        view.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: 60).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: SettingCell.id)
        collectionView.register(ContentTypeSettingCell.self, forCellWithReuseIdentifier: ContentTypeSettingCell.id)
        collectionView.register(ButtonCell.self, forCellWithReuseIdentifier: ButtonCell.id)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animateAlongsideTransition(in: nil, animation: nil, completion: { [weak self] context in
            self?.collectionView.collectionViewLayout.invalidateLayout()
        })
    }
    
    @objc func closeButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0, 1: return CGSize(width: collectionView.bounds.size.width, height: 100)
        default: return CGSize(width: collectionView.bounds.size.width / 3, height: 100)
        }
    }
}
