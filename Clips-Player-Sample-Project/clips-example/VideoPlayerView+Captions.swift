//
//  VideoPlayerView.swift
//  Clips-Example
//
//  Created by Alex on 11.3.2022.
//  Copyright © 2022 GIPHY. All rights reserved.
//

import Foundation
import AVFoundation

extension VideoPlayerView {
    @objc func toggleCaptions() {
        captionButton.on = !captionButton.on
        showControls()
        let on = captionButton.on
        if on {
            enableCaptions()
        } else {
            disableCaptions()
        }
        CaptionState.setEnabled(on)
    }
    
    func captionsAvailable() -> Bool {
        guard let player = player else { return false }
        guard let item = player.currentItem else { return false }
        let locale = Locale.current
        guard let group = item.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else { return false }
        let options = AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, with: locale)
        return !options.isEmpty
    }
    
    func setOptionsForMediaCharacteristic(_ characteristic: AVMediaCharacteristic) {
        guard let player = player as? AVQueuePlayer else { return }
        for item in player.items() {
            player.appliesMediaSelectionCriteriaAutomatically = false
            let locale = Locale.current
            guard let group = item.asset.mediaSelectionGroup(forMediaCharacteristic: characteristic) else { return }
            let options = AVMediaSelectionGroup.mediaSelectionOptions(from: group.options, with: locale)
            if let option = options.first { item.select(option, in: group) }
        }
    }
    
    func enableCaptions() {
        setOptionsForMediaCharacteristic(.legible)
    }
    
    func disableCaptions() {
        guard let player = player as? AVQueuePlayer else { return }
        for item in player.items() {
            guard let group = item.asset.mediaSelectionGroup(forMediaCharacteristic: .legible) else { return }
            item.select(nil, in: group)
        }
    }
        
    
}

