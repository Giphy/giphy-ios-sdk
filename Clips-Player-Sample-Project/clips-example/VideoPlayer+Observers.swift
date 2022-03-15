//
//  VideoPlayer+Observers.swift
//  Clips-Example
//
//  Created by Alex on 11.3.2022.
//  Copyright © 2022 GIPHY. All rights reserved.
//

import UIKit
import AVFoundation

extension VideoPlayer {
    
    func removePlayerObservers() {
        lock.lock()
        defer { lock.unlock() }
        
        guard let player = videoPlayer else { return }
        
        player.removeObserver(self, forKeyPath: #keyPath(AVQueuePlayer.currentItem))
        player.removeObserver(self, forKeyPath: #keyPath(AVQueuePlayer.currentItem.status))
        player.removeObserver(self, forKeyPath: #keyPath(AVQueuePlayer.isMuted))
        player.removeObserver(self, forKeyPath: #keyPath(AVQueuePlayer.timeControlStatus))
    }
    
    func addPlayerObservers() {
        lock.lock()
        defer { lock.unlock() }
        
        guard let player = videoPlayer else { return }
        
        player.addObserver(self, forKeyPath: #keyPath(AVQueuePlayer.currentItem), options: [.old, .new], context: &playerItemContext)
        player.addObserver(self, forKeyPath: #keyPath(AVQueuePlayer.currentItem.status), options: [.old, .new], context: &playerItemStatusContext)
        player.addObserver(self, forKeyPath: #keyPath(AVQueuePlayer.isMuted), options: [.old, .new], context: &playerMuteContext)
        player.addObserver(self, forKeyPath: #keyPath(AVQueuePlayer.timeControlStatus), options: [.old, .new], context: &playerStatusContext)
    }
  
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
                
        guard let player = videoPlayer else { return }
        
        if context == &playerStatusContext {
            if
                let change = change,
                let newValue = change[NSKeyValueChangeKey.newKey] as? Int,
                let oldValue = change[NSKeyValueChangeKey.oldKey] as? Int {
                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                
                if newStatus != oldStatus {
                    switch newStatus {
                    case .playing:
                        notifyListeners { $0.playerStateDidChange?(.playing) }
                    case .paused:
                        notifyListeners { $0.playerStateDidChange?(.paused) }
                    case .waitingToPlayAtSpecifiedRate:
                        notifyListeners { $0.playerStateDidChange?(.idle) }
                    default:
                        break
                    }
                } else {
                    if newStatus == .playing {
                        notifyListeners { $0.playerStateDidChange?(.repeated) }
                    }
                }
            }
        } else if context == &playerMuteContext {
            notifyListeners { $0.muteDidChange?(isMuted: player.isMuted) }
        } else if context == &playerItemContext {
        } else if context == &playerItemStatusContext {
            guard let currentItem = player.currentItem else { return }
            
            switch currentItem.status {
            case .failed:
                notifyListeners { $0.playerDidFail?(currentItem.error?.localizedDescription) }
            case .unknown:
                notifyListeners { $0.playerStateDidChange?(.unknown) }
            case .readyToPlay:
                if firstStart {
                    firstStart = false
                    notifyListeners { $0.playerStateDidChange?(.readyToPlay) }
                }
            @unknown default:
                break
            }
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}


