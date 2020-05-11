//
//  ChatCell.swift
//  Example
//
//  Created by Jonny Mclaughlin on 3/20/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//



import UIKit
import GiphyUISDK
import GiphyCoreSDK

class ChatCell: UICollectionViewCell {
    static let id: String = "ChatCell"
    static let padding: CGFloat = 20
    static let bubbleWidth: CGFloat = 250
    static let emojiBubbleWidth: CGFloat = 60
    static let font: UIFont = .systemFont(ofSize: 14)
    
    let imageView = GPHMediaView()
    let avatarImageView = GiphyYYAnimatedImageView()
    
    var media: GPHMedia? {
        didSet {
            addMedia()
        }
    }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    var avatarImage: GiphyYYImage? {
        didSet {
            avatarImageView.image = avatarImage
        }
    }
    
    var isReply: Bool = false {
        didSet {
            avatarLeftConstraint?.isActive = isReply
            avatarRightConstraint?.isActive = !isReply
            bubbleLeftConstraint?.isActive = isReply
            bubbleRightConstraint?.isActive = !isReply
        }
    }
    
    var theme = GPHThemeType.light {
        didSet {
            switch theme {
            case GPHThemeType.automatic, GPHThemeType.light:
                if media == nil {
                    bubbleView.backgroundColor = isReply ? .white : UIColor(red: 1.00, green :0.40, blue: 0.40, alpha: 1.0)
                }
                label.textColor = isReply ? UIColor(red: 0.27, green: 0.27, blue: 0.30, alpha: 1.0) : .white
                break
            case GPHThemeType.dark:
                if media == nil {
                    bubbleView.backgroundColor = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
                }
                label.textColor = .white
                break
            default: break
            }
        }
    }
    
    var assetRequest: URLSessionDataTask?
    var bubbleLeftConstraint: NSLayoutConstraint?
    var bubbleRightConstraint: NSLayoutConstraint?
    var avatarLeftConstraint: NSLayoutConstraint?
    var avatarRightConstraint: NSLayoutConstraint?
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = ChatCell.font
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(bubbleView)
        bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        bubbleView.widthAnchor.constraint(equalToConstant: ChatCell.bubbleWidth).isActive = true
        
        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.masksToBounds = false
        bubbleView.layer.shadowColor = UIColor.black.cgColor
        bubbleView.layer.shadowOpacity = 0.12
        bubbleView.layer.shadowRadius = 25
        bubbleView.layer.shadowOffset = CGSize(width: 0, height: 13)
        
        contentView.addSubview(avatarImageView)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor, multiplier: 1.33).isActive = true
        avatarImageView.isUserInteractionEnabled = false
        
        avatarLeftConstraint = avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: ChatCell.padding)
        avatarRightConstraint = avatarImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -ChatCell.padding)
        bubbleLeftConstraint = bubbleView.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 5)
        bubbleRightConstraint = bubbleView.rightAnchor.constraint(equalTo: avatarImageView.leftAnchor, constant: -5)
        
        bubbleView.addSubview(label)
        label.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: ChatCell.padding).isActive = true
        label.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: ChatCell.padding).isActive = true
        label.rightAnchor.constraint(equalTo: bubbleView.rightAnchor, constant: -ChatCell.padding).isActive = true
        label.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -ChatCell.padding).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addMedia() {
        guard let media = media else { return }
        label.isHidden = true
        bubbleView.backgroundColor = .clear
        bubbleView.addSubview(imageView)
        imageView.media = media
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: media.aspectRatio).isActive = true
        imageView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        imageView.isUserInteractionEnabled = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = bubbleView.layer.cornerRadius
        imageView.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bubbleLeftConstraint?.isActive = false
        bubbleRightConstraint?.isActive = false
        avatarLeftConstraint?.isActive = false
        avatarRightConstraint?.isActive = false
        assetRequest?.cancel()
        assetRequest = nil
        imageView.image = nil
        avatarImageView.image = nil
        label.text = ""
        label.isHidden = false
    }
}
