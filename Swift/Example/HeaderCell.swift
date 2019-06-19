//
//  HeaderCell.swift
//  Example
//
//  Created by Jonny Mclaughlin on 6/11/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import UIKit

class HeaderCell: UICollectionReusableView {
    static let id: String = "HeaderCell"
    static let textColor: UIColor = UIColor(white: 0.5, alpha: 1.0)
    
    var title: String? {
        didSet {
            textLabel.text = title
        }
    }
    
    let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(textLabel)
        textLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textLabel.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        textLabel.textColor = HeaderCell.textColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        title = ""
    }
}
