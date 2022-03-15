//
//  VideoPlayerView.swift
//  Clips-Example
//
//  Created by Alex on 11.3.2022.
//  Copyright © 2022 GIPHY. All rights reserved.
//

import Foundation

struct GPHVideoPlayerViewConstants {
    static let hideControlsInitialDelay: TimeInterval = 3.0
    static let hideControlsDelay: TimeInterval = 2.0
    static let hideControlsDuration: TimeInterval = 0.4
}

extension VideoPlayerView: VideoPlayerStateListener {
 
    public func playerStateDidChange(_ state: VideoPlayerState) {
        
        lock.lock()
        defer { lock.unlock() }
        
        guard media === videoPlayer?.media else { return }
        
        switch state {
        case .unknown:
            break
        case .readyToPlay:
            if let player = videoPlayer?.videoPlayer {
                playerLayer.player = player
            }
            
            shimmerView.isHidden = true
        case .playing:
            showControls(delayToHide: GPHVideoPlayerViewConstants.hideControlsInitialDelay)
        case .paused:
            showControls(delayToHide: GPHVideoPlayerViewConstants.hideControlsInitialDelay)
        case .repeated:
            if loopCount + 1 > maxLoopsBeforeMute - 1 {
                automute()
            } else {
                loopCount += 1
            }
        case .idle:
            break
        }
    }
    
    public func playerDidFail(_ description: String?) {
        
    }
    
    public func muteDidChange(isMuted: Bool) {
        guard media === videoPlayer?.media else { return }
        
        loopCount = 0
        soundButton.on = !isMuted
        
        if isMuted {
            soundButton.alpha = 1
        }
    }
    
    public func mediaDidChange(media: Media?) {
        lock.lock()
        defer { lock.unlock() }
        
        guard self.media !== media else { return }
        resetControlsState()
        loopCount = 0
        shimmerView.isHidden = true
        imageView.isHidden = false
        
        videoPlayer?.remove(listener: self)
    }
}

