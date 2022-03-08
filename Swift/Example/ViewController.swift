//
//  ViewController.swift
//  Example
//
//  Created by Chris Maier on 2/12/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import UIKit
import GiphyUISDK

class ViewController: UIViewController {
    static let shadowOpacity: Float = 0.12
    static let shadowColor: UIColor = .black
    static let padding: CGFloat = 20
    static let darkHeaderColor: UIColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
    static let darkTextFieldBorderColor: UIColor = UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.0)
    static let headerHeight: CGFloat = 80
    
    let settingsViewController = SettingsViewController()
    var textFieldBottomConstraint: NSLayoutConstraint?
    var textFieldLeftConstraint: NSLayoutConstraint?
    var conversation: [ChatMessage] = [
        ChatMessage(text: "Hi there! The SDK is perfect for many contexts, including messaging, reactions, stories and other camera features. This is one example of how the GIPHY SDK can be used in a messaging app.", user: .abraHam),  ChatMessage(text: "Tap the GIPHY button in the bottom left to see the SDK in action. Tap the settings icon in the top right to try out all of the customization options.", user: .abraHam)
    ]
    let conversationResponses: [String] = [
        "please stop texting me",
        "please stop...",
        "dude...",
        "seriously, stop",
        "STAAAAHHHHPPPP",
        "ur ruining my life",
        "ur killing my battery",
        "ur dead 2 me",
    ]
    var currentConversationResponse = 0
    
    let header: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let avatar: GiphyYYAnimatedImageView = {
        let path = Bundle(for: ViewController.self).path(forResource: "abraham", ofType: "gif")
        let image = GiphyYYImage(contentsOfFile: path ?? "")
        let imageView = GiphyYYAnimatedImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.33).isActive = true
        return imageView
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textFieldContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .clear
        textField.clearButtonMode = .whileEditing
        textField.attributedPlaceholder = NSAttributedString(string: "Type message...", attributes: [NSAttributedString.Key.foregroundColor: UIColor(white: 0.5, alpha: 1)])
        textField.textColor = .black
        textField.returnKeyType = .send
        return textField
    }()
    
    var gifButton: UIButton = {
        let button = UIButton()
        button.setImage(GPHIcons.giphyLogo(), for: .normal)
        button.accessibilityLabel = "GIF_BUTTON"
        return button
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.backgroundColor = .clear
        button.setBackgroundImage(UIImage(named: "SendButton"), for: .normal)
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.backgroundColor = .clear
        button.setImage(UIImage(named: "SettingsButton"), for: .normal)
        return button
    }()
    
    let videoPlayer = GPHVideoPlayer()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return view.backgroundColor == .black ? .lightContent : .default
    }

    override func viewDidLoad() {
        super.viewDidLoad() 
        addChatView()
        registerKeyboardNotifications()
        view.backgroundColor = .white
    }
    
    func addChatView() {
    
        view.addSubview(textFieldContainer)
        textFieldContainer.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: 10).isActive = true
        textFieldContainer.rightAnchor.constraint(equalTo: view.safeRightAnchor, constant: -10).isActive = true
        textFieldBottomConstraint = textFieldContainer.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -10)
        textFieldBottomConstraint?.isActive = true
        textFieldContainer.heightAnchor.constraint(equalToConstant: 45).isActive = true
        textFieldContainer.backgroundColor = .white
        textFieldContainer.layer.borderWidth = 1
        textFieldContainer.layer.borderColor = UIColor.white.cgColor
        textFieldContainer.layer.masksToBounds = false
        textFieldContainer.layer.cornerRadius = 8
        textFieldContainer.layer.shadowColor = ViewController.shadowColor.cgColor
        textFieldContainer.layer.shadowOpacity = ViewController.shadowOpacity
        textFieldContainer.layer.shadowOffset = .zero
        textFieldContainer.layer.shadowRadius = 25
        
        textFieldContainer.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: textFieldContainer.rightAnchor, constant: -10).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: textFieldContainer.centerYAnchor).isActive = true
        sendButton.addTarget(self, action: #selector(sendText), for: .touchUpInside)
        
        textFieldContainer.addSubview(textField)
        textFieldLeftConstraint = textField.leftAnchor.constraint(equalTo: textFieldContainer.leftAnchor)
        textFieldLeftConstraint?.isActive = true
        textField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5).isActive = true
        textField.heightAnchor.constraint(equalTo: textFieldContainer.heightAnchor).isActive = true
        textField.topAnchor.constraint(equalTo: textFieldContainer.topAnchor).isActive = true
        textField.addTarget(self, action: #selector(sendText), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(textEditingExit), for: .editingDidEndOnExit)
        
        view.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: view.safeLeftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeTopAnchor, constant: ViewController.headerHeight).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeRightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: textFieldContainer.topAnchor).isActive = true
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.id)
        collectionView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 20, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(header)
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        header.bottomAnchor.constraint(equalTo: view.safeTopAnchor, constant: 80).isActive = true
        header.backgroundColor = .white
        header.layer.masksToBounds = false
        header.layer.shadowColor = ViewController.shadowColor.cgColor
        header.layer.shadowOpacity = ViewController.shadowOpacity
        header.layer.shadowOffset = CGSize(width: 0, height: 25)
        header.layer.shadowRadius = 13
        
        header.addSubview(settingsButton)
        settingsButton.rightAnchor.constraint(equalTo: header.safeRightAnchor, constant: -10).isActive = true
        settingsButton.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10).isActive = true
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        view.addSubview(avatar)
        avatar.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        avatar.centerYAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        
        textFieldContainer.addSubview(gifButton)
        gifButton.translatesAutoresizingMaskIntoConstraints = false
        gifButton.widthAnchor.constraint(equalToConstant: 30.0).isActive = true
        gifButton.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        gifButton.leftAnchor.constraint(equalTo: textFieldContainer.leftAnchor, constant: 6).isActive = true
        gifButton.centerYAnchor.constraint(equalTo: textFieldContainer.centerYAnchor).isActive = true
        gifButton.addTarget(self, action: #selector(gifButtonTapped), for: .touchUpInside)
        textFieldLeftConstraint?.constant = gifButton.intrinsicContentSize.width + 15
        
        settingsViewController.delegate = self
         
    }
    
    func updateChatColors(_ theme: GPHThemeType) {
        let isDark = theme == .dark
        textFieldContainer.backgroundColor = isDark ? .black : .white
        textFieldContainer.layer.borderColor = isDark ? ViewController.darkTextFieldBorderColor.cgColor : UIColor.white.cgColor
        textField.textColor = isDark ? .white : .black
        textField.keyboardAppearance = isDark ? .dark : .light
        header.backgroundColor = isDark ? ViewController.darkHeaderColor : .white
        collectionView.reloadData()
        view.backgroundColor = isDark ? .black : .white
    }
    
    func addMessageToConversation(text: String? = nil, media: GPHMedia? = nil, user: ChatUser = .sueRender) {
        let indexPath = IndexPath(row: conversation.count, section: 0)
        for (index, _) in conversation.enumerated() {
            conversation[index].playClipOnLoad = false
        }
        conversation.append(ChatMessage(text: text, user: user, media: media, playClipOnLoad: media?.isVideo ?? false))
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.collectionView.insertItems(at: [indexPath])
        })
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    @objc func sendText() {
        if !(textField.text ?? "").isEmpty {
            addMessageToConversation(text: textField.text, media: nil)
        }
        textField.text = nil
        textField.resignFirstResponder()
    }
    
    @objc func gifButtonTapped() {
        videoPlayer.pause()
        
        let giphy = GiphyViewController()
        giphy.theme = GPHTheme(type: settingsViewController.theme)
        giphy.mediaTypeConfig = settingsViewController.mediaTypeConfig
        GiphyViewController.trayHeightMultiplier = 0.7  
        giphy.showConfirmationScreen = settingsViewController.confirmationScreen == .on
        giphy.shouldLocalizeSearch = true
        giphy.delegate = self
        giphy.dimBackground = true
        giphy.enableDynamicText = settingsViewController.dynamicResultsInTextSearch == .on
         
        giphy.modalPresentationStyle = .overCurrentContext
        
        if let contentType = self.selectedContentType {
            giphy.selectedContentType = contentType
        }
        if let user = self.showMoreByUser {
            giphy.showMoreByUser = user
            self.showMoreByUser = nil 
        }
        
        present(giphy, animated: true, completion: nil)
    } 
    
    @objc func textEditingExit() {
        textField.resignFirstResponder()
    }
    
    @objc func settingsButtonTapped() {
        present(settingsViewController, animated: true, completion: nil)
    }
    
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var selectedContentType: GPHContentType?
    var showMoreByUser: String?
}

public class ExampleTheme: GPHTheme {
    public override init() {
        super.init()
        self.type = .light
    }
    
    public override var textFieldFont: UIFont? {
        return UIFont.italicSystemFont(ofSize: 15.0)
    }
      
    public override var textColor: UIColor {
        return .black
    }

    public override var stickerBackgroundColor: UIColor { return .clear }

    public override var tabBarSwitchSelectedColor: UIColor { return .yellow }

}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        guard index < conversation.count else { return .zero }
        let message = conversation[index]
        if let media = message.media {
            let isEmoji = media.isEmoji
            let size = CGSize(width: media.images?.original?.width ?? 1, height: media.images?.original?.height ?? 1)
            let ratio = size.width / size.height
            return CGSize(width: collectionView.bounds.size.width, height: (isEmoji ? ChatCell.emojiBubbleWidth : ChatCell.bubbleWidth) / ratio)
        }
        guard let text = message.text else { return .zero }
        let targetSize = CGSize(width: ChatCell.bubbleWidth - ChatCell.padding * 2, height: .greatestFiniteMagnitude)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        let textRect = text.boundingRect(with: targetSize, options: .usesLineFragmentOrigin, attributes: [.font: ChatCell.font, .paragraphStyle: style], context: nil)
        return CGSize(width: collectionView.bounds.size.width, height: ceil(textRect.height + ChatCell.padding * 2))
    }
}

extension ViewController: SettingsDelegate {
    func themeDidChange(_ theme: GPHThemeType) {
        updateChatColors(theme)
    }
} 

extension ViewController: GiphyDelegate {
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia, contentType: GPHContentType) {
        print(contentType.rawValue)
    }
    
    func didSearch(for term: String) {
        print("your user made a search! ", term)
    }
    
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        showMoreByUser = nil 
        self.selectedContentType = giphyViewController.selectedContentType
        giphyViewController.dismiss(animated: true, completion: { [weak self] in
            self?.addMessageToConversation(text: nil, media: media)
            guard self?.conversation.count ?? 0 > 7 else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
                guard let self = self else { return }
                let response = self.conversationResponses[self.currentConversationResponse % self.conversationResponses.count]
                self.currentConversationResponse += 1
                self.addMessageToConversation(text: response, user: .abraHam)
            }
        })
        GPHCache.shared.clear()
    }
    
    func didDismiss(controller: GiphyViewController?) {
        GPHCache.shared.clear()
    }
}

extension ViewController: GPHMediaViewDelegate {
    func didPressMoreByUser(_ user: String) {
        showMoreByUser = user
        gifButtonTapped()
    }
}
