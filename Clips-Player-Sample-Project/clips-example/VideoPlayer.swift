//
//  VideoPlayer.swift
//  Clips-Example
//
//  Created by Alex on 11.3.2022.
//  Copyright © 2022 GIPHY. All rights reserved.
//

import UIKit
import AVFoundation

@objc public class Media: NSObject {
    public fileprivate(set) var videoUrl: String
    public fileprivate(set) var imagePreviewUrl: String?
    public fileprivate(set) var aspectRatio: CGFloat
    
    public init(videoUrl: String, imagePreviewUrl: String?, aspectRatio: CGFloat) {
        self.videoUrl = videoUrl
        self.imagePreviewUrl = imagePreviewUrl
        self.aspectRatio = aspectRatio
        super.init()
    }
}

@objc public enum VideoPlayerState: Int {
    case unknown
    case readyToPlay
    case playing
    case paused
    case repeated
    case idle
}

@objc public protocol VideoPlayerStateListener: AnyObject {
    @objc optional func playerStateDidChange(_ state: VideoPlayerState)
    @objc optional func playerDidFail(_ description: String?)
    @objc optional func muteDidChange(isMuted: Bool)
    @objc optional func mediaDidChange(media: Media?)
}

// maintain the caption state if you like
public class CaptionState: NSObject {
    static let key = "kGPHClipsCaptionState"
    
    public static var enabled: Bool {
        guard let state = UserDefaults.standard.object(forKey: CaptionState.key) as? Bool else {
            return false
        }
        return state
    }
    
    class func setEnabled(_ enabled: Bool) {
        UserDefaults.standard.setValue(enabled, forKey: CaptionState.key)
        UserDefaults.standard.synchronize()
    }
}

@objcMembers
public class VideoPlayer: NSObject {
    private var listeners = [VideoPlayerStateListener]()
    
    private var videoPlayerLooper: AVPlayerLooper?
    private(set) var videoPlayer: AVQueuePlayer?
    
    private(set) var media: Media?
    
    public weak var playerView: VideoPlayerView?
    
    let lock = NSRecursiveLock()
    
    var firstStart = false
    
    var playerMuteContext = 0
    var playerStatusContext = 0
    var playerItemStatusContext = 0
    var playerItemContext = 0
    
    var repeatable: Bool = true
    
    // MARK: -
    // MARK: Init
    
    public override init() {
        super.init()
    }
    
    // MARK: -
    // MARK: Actions
    
    func notifyListeners(action: (VideoPlayerStateListener) -> Void) {
        lock.lock()
        defer { lock.unlock() }
        
        listeners.forEach({
            action($0)
        })
    }
    
    deinit {
        stop()
    }
}

// MARK: -
// MARK: Public APIs
extension VideoPlayer {
    public func add(listener: VideoPlayerStateListener) {
        lock.lock()
        defer { lock.unlock() }
        
        if listeners.firstIndex(where: {$0 === listener}) == nil {
            listeners.append(listener)
        }
        
    }

    public func remove(listener: VideoPlayerStateListener) {
        lock.lock()
        defer { lock.unlock() }
        
        guard let index = listeners.firstIndex(where: { $0 === listener }) else { return }
        listeners.remove(at: index)
    }
    
    public func prepare(media: Media,
                        view: VideoPlayerView?) {
        lock.lock()
        defer { lock.unlock() }
        
        self.playerView = view
        
        view?.preloadFirstFrame(media: media, videoPlayer: self)
    }
    
    public func loadMedia(media: Media,
                          autoPlay: Bool = true,
                          muteOnPlay: Bool = false,
                          view: VideoPlayerView,
                          repeatable: Bool = true) {
        lock.lock()
        defer { lock.unlock() }
        
        self.playerView = view
                
        stop()
        
        self.repeatable = repeatable
        self.firstStart = true
        self.media = media
        
        notifyListeners(action: { $0.mediaDidChange?(media: media) })
                
        guard let url = URL(string: media.videoUrl) else {
            return
        }
        
        let asset = AVAsset(url: url)
        let keys: [String] = ["playable"]
        asset.loadValuesAsynchronously(forKeys: keys) { [weak self] in
            DispatchQueue.main.async {
                guard self?.media === media else { return }
                                
                let playerItem = AVPlayerItem(asset: asset)
                let videoPlayer = AVQueuePlayer(items: [playerItem])
                self?.videoPlayer = videoPlayer
                if repeatable {
                    self?.videoPlayerLooper = AVPlayerLooper(player: videoPlayer, templateItem: playerItem)
                }
                self?.addPlayerObservers()
                
                if (muteOnPlay) {
                    self?.mute(true)
                }
                
                if autoPlay {
                    videoPlayer.play()
                }
            }
        }
        view.prepare(media: media, videoPlayer: self)
    }
    
    public func pause() {
        videoPlayer?.pause()
    }
    
    public func resume() {
        videoPlayer?.play()
    }
    
    public func mute(_ isMuted: Bool) {
        videoPlayer?.isMuted = isMuted
    }
    
    public func stop() {
        removePlayerObservers()
        videoPlayer?.pause()
        videoPlayer = nil
        videoPlayerLooper = nil
    }
    
}
