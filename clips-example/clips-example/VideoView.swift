//
//  VideoView.swift
//  Example
//
//  Created by Christopher Maier on 7/20/21.
//  Copyright © 2021 GIPHY. All rights reserved.
//

import UIKit
import AVFoundation

/*
This file represents sample code for a simple video player view, complete with looping capabilities, a sound control, and a "shimmering" animation to indicate the video loading state. These components are intended to be generic and independent of the SDK.

 Learn more about Clips (GIFs with Sound!) in the clips.md file.
  
*/

// public interface
public extension VideoView {
    
    func load(_ url: String?) {
        // remove any player observers 
        removePlayerObservers()
        guard let url = url, let url = URL(string: url) else {
            return
        }
        let playerItem = AVPlayerItem(url: url)
        let queuePlayer = AVQueuePlayer(items: [playerItem])
        self.looper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        self.queuePlayer = queuePlayer
        playerLayer.player = queuePlayer
    }
    
    
    func play() {
        loopCount = 0
        player?.play()
        player?.isMuted = true
        speakerButton.on = false
        addPlayerObservers()
    }
    
    func pause() {
        player?.pause()
    }
    
    func mute() {
        player?.isMuted = true
        speakerButton.on = false
    }
    
    func unmute() {
        player?.isMuted = false
        speakerButton.on = true
        
    }
}

 
@objc public enum VideoPlayerState: Int {
    case unknown
    case readyToPlay
    case playing
    case paused
}

@objc public protocol VideoViewDelegate: AnyObject {
    @objc optional func playerStateDidChange(videoView: VideoView?, state: VideoPlayerState)
    @objc optional func playerDidFail(videoView: VideoView?, description: String?)
    @objc optional func muteDidChange(videoView: VideoView?, muted: Bool)
}

class SpeakerButton: UIButton {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        updateIcon()
        tintColor = .white
    }
    
    var on: Bool = false {
        didSet {
            updateIcon()
        }
    }
    
    func updateIcon() {
        guard #available(iOS 13.0, *) else { return }
        if on {
            setImage(UIImage(systemName: "speaker.wave.3")?.withRenderingMode(.alwaysTemplate), for: .normal)
        } else {
            setImage(UIImage(systemName: "speaker.slash")?.withRenderingMode(.alwaysTemplate), for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
@objcMembers
public class VideoView: UIView {
     
    
    // must maintain a strong reference to the AVPlayerLooper
    var looper: AVPlayerLooper?
    
    var queuePlayer: AVQueuePlayer?
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
     
    public override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    public weak var delegate: VideoViewDelegate?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     
    public override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
         

        // add loading view
        shimmerView.isUserInteractionEnabled = false
        addSubview(shimmerView)
        shimmerView.topAnchor.constraint(lessThanOrEqualTo: topAnchor).isActive = true
        shimmerView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        shimmerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        shimmerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        shimmerView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        shimmerView.backgroundColor = UIColor.randomColor 
        shimmerView.shimmer(true, isSticker: false, backgroundColor: UIColor.blue)

        // add speaker button
        addSubview(speakerButton)
        speakerButton.isHidden = true
        speakerButton.isUserInteractionEnabled = false
        speakerButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        speakerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        speakerButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        speakerButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
 
        // tapping anywhere on the video view toggles the audio
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleAudio))
        addGestureRecognizer(tap)
        
    }
      
    var playerMuteContext = 0
    var playerStatusContext = 0
    var playerItemStatusContext = 0
    var playerItemContext = 0
      
    deinit {
        removePlayerObservers()
    }
     
    let speakerButton: SpeakerButton = {
        let button = SpeakerButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let shimmerView: ShimmerLoadingView = {
        let view = ShimmerLoadingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.animate()
        return view
    }()
      
    @objc func toggleAudio() {
        guard let player = player else { return }
        loopCount = 0
        speakerButton.on = !speakerButton.on
        player.isMuted = !speakerButton.on
        if player.timeControlStatus == .paused {
            player.play()
        }
    }
      
    public var maxLoopsBeforeMute = 3
    var loopCount = 0
    
    @objc func automute() {
        player?.isMuted = true
        speakerButton.on = false
    }
}
  
public extension VideoView {
    func removePlayerObservers() {
        guard let queuePlayer = player else { return }
        queuePlayer.removeObserver(self, forKeyPath: #keyPath(AVQueuePlayer.currentItem))
        queuePlayer.removeObserver(self, forKeyPath: #keyPath(AVQueuePlayer.currentItem.status))
        queuePlayer.removeObserver(self, forKeyPath: #keyPath(AVQueuePlayer.isMuted))
        queuePlayer.removeObserver(self, forKeyPath: #keyPath(AVQueuePlayer.timeControlStatus))
    }
    
    func addPlayerObservers() {
        guard let queuePlayer = player else { return }
        queuePlayer.addObserver(self, forKeyPath: #keyPath(AVQueuePlayer.currentItem), options: [.old, .new], context: &playerItemContext)
        queuePlayer.addObserver(self, forKeyPath: #keyPath(AVQueuePlayer.currentItem.status), options: [.old, .new], context: &playerItemStatusContext)
        queuePlayer.addObserver(self, forKeyPath: #keyPath(AVQueuePlayer.isMuted), options: [.old, .new], context: &playerMuteContext)
        queuePlayer.addObserver(self, forKeyPath: #keyPath(AVQueuePlayer.timeControlStatus), options: [.old, .new], context: &playerStatusContext)
    }
  
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // Based on https://developer.apple.com/documentation/avfoundation/media_assets_playback_and_editing/responding_to_playback_state_changes
        guard let queuePlayer = player else { return }
        if context == &playerStatusContext {
            switch queuePlayer.timeControlStatus {
            case .playing:
                delegate?.playerStateDidChange?(videoView: self, state: .playing)
                
                if loopCount > 2 {
                    automute()
                }
                loopCount += 1
                
                DispatchQueue.main.async { [weak self] in
                    self?.shimmerView.isHidden = true
                    self?.speakerButton.isHidden = false
                    self?.setNeedsLayout()
                }
                break
            case .paused:
                delegate?.playerStateDidChange?(videoView: self, state: .paused)
            case .waitingToPlayAtSpecifiedRate: break
            default:
                break
            }
        } else if context == &playerMuteContext {
            delegate?.muteDidChange?(videoView: self, muted: queuePlayer.isMuted)
        } else if context == &playerItemContext {
        } else if context == &playerItemStatusContext {
            guard let currentItem = queuePlayer.currentItem else { return }
            
            switch currentItem.status {
            case .readyToPlay:
                delegate?.playerStateDidChange?(videoView: self, state: .readyToPlay)
            case .failed:
                delegate?.playerDidFail?(videoView: self, description: queuePlayer.currentItem?.error?.localizedDescription)
            case .unknown:
                delegate?.playerStateDidChange?(videoView: self, state: .unknown)
            @unknown default:
                break
            }
            
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
}
 

extension ViewController: VideoViewDelegate { 
    func playerStateDidChange(videoView: VideoView?, state: VideoPlayerState) {
    }
    
    func playerDidFail(videoView: VideoView?, description: String?) {
    }
    
    // is this the system mute?
    func muteDidChange(videoView: VideoView?, muted: Bool) {
        if muted == false {
            muteAllVideoPlayersExcept(activeView: videoView)
        }
    }
}
