//
//  SoundButton.swift
//  GiphyUISDK
//
//  Created by Christopher Maier on 5/21/21.
//  Copyright © 2021 GIPHY. All rights reserved.
//

import UIKit

enum ToggleButtonType {
    case sound
    case caption
    
    var imageForOnState: UIImage? {
        switch self {
        case .sound:
            return UIImage(systemName: "speaker.wave.3")?.withRenderingMode(.alwaysTemplate)
        case .caption:
            return UIImage(systemName: "captions.bubble.fill")?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var imageForOffState: UIImage? {
        switch self {
        case .sound:
            return UIImage(systemName: "speaker.slash")?.withRenderingMode(.alwaysTemplate)
        case .caption:
            return UIImage(systemName: "captions.bubble")?.withRenderingMode(.alwaysTemplate)
        }
    }
}

class ToggleButton: UIButton {
    var type: ToggleButtonType = .sound {
        didSet {
            updateIcon()
        }
    }
     
    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
         
        updateIcon()
    }
    
    var on: Bool = false {
        didSet {
            updateIcon()
        }
    }
    
    func updateIcon() {
        if on {
            setImage(type.imageForOnState, for: .normal)
        } else {
            setImage(type.imageForOffState, for: .normal)
        }
        tintColor = .white

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
 
  
