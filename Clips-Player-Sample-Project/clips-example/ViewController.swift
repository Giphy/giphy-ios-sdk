//
//  ViewController.swift
//  Clips
//
//  Created by Christopher Maier on 8/4/21.
//

import UIKit
import GiphyUISDK
 

class Clip {
    var media: Media?
    // store a weak reference to the video view here
    weak var videoView: VideoPlayerView?
    var playClipOnLoad: Bool = false
}

class ClipCell: UICollectionViewCell  {
    static let id: String = "ClipCell"
    var videoView = VideoPlayerView()
    var videoPlayer: VideoPlayer?
    
    var media: Media? {
        didSet {
            guard let media = media else { return }
            addSubview(videoView)
            videoView.translatesAutoresizingMaskIntoConstraints = false
            videoView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
            videoView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: media.aspectRatio).isActive = true
            videoView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            videoView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
            videoView.contentMode = .scaleAspectFit
            videoView.layer.masksToBounds = true
            videoView.backgroundColor = .clear
        }
    }
}

class ViewController: UIViewController {
    
    let videoPlayer = VideoPlayer()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    var clips = [Clip]()
    
    func addClipForMedia(_ media: GPHMedia) {
        let indexPath = IndexPath(row: clips.count, section: 0)

        let clip = Clip()
        clip.playClipOnLoad = true
        clip.media = Media(videoUrl: media.smallVideoAssetURL ?? "",
                           imagePreviewUrl: media.images?.originalStill?.gifUrl, aspectRatio: media.aspectRatio)
        clips.append(clip)
        UIView.animate(withDuration: 0, animations: { [weak self] in
            self?.collectionView.insertItems(at: [indexPath])
        })
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)

     }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let padding: CGFloat = 20.0
        view.backgroundColor = .giphyBlack
        view.addSubview(collectionView)
         
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true

        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        
        collectionView.register(ClipCell.self, forCellWithReuseIdentifier: ClipCell.id)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        view.addSubview(giphyButton)
        giphyButton.bottomAnchor.constraint(equalTo: view.safeBottomAnchor, constant: -padding).isActive = true
        giphyButton.leftAnchor.constraint(equalTo: view.safeLeftAnchor, constant: padding).isActive = true
        giphyButton.addTarget(self, action: #selector(presentGIPHY), for: .touchUpInside)
         

    }
    
    var giphyButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(GPHIcons.giphyLogo(), for: .normal)
        return button
    }()
    
    @objc
    func presentGIPHY() {
        Giphy.configure(apiKey: "YOUR_API_KEY")
        let giphy = GiphyViewController()
        giphy.mediaTypeConfig = [.clips]
        giphy.delegate = self
        present(giphy, animated: true, completion: nil)
        
    }

}
  
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let genericCell = collectionView.dequeueReusableCell(withReuseIdentifier: ClipCell.id, for: indexPath)
        guard let cell = genericCell as? ClipCell else { return genericCell }
        let clip = clips[indexPath.item]
        cell.videoPlayer = videoPlayer
        cell.media = clip.media
        // store a weak reference to the video. this enables us to keep track of all allocated video views
        clip.videoView = cell.videoView
        cell.layer.cornerRadius = 5
        cell.clipsToBounds = true
        
        videoPlayer.pause()
        if let media = clip.media {
            if clip.playClipOnLoad {
                videoPlayer.loadMedia(media: media,
                                      muteOnPlay: true,
                                      view: cell.videoView)
            } else {
                videoPlayer.prepare(media: media,
                                    view: cell.videoView)
            }
        }
        // To ensure we don't start playing it every time the cell becomes visible.
        clips[indexPath.item].playClipOnLoad = false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return clips.count
    }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        guard index < clips.count else { return .zero }
        let clip = clips[index]
        if let media = clip.media {
            let width: CGFloat = collectionView.frame.size.width
            return CGSize(width: width, height: width / media.aspectRatio)
        }
        return CGSize.zero
    }
}

extension ViewController: GiphyDelegate {
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia, contentType: GPHContentType) {
        print(contentType.rawValue)
    }
    
    func didSearch(for term: String) {
        print("your user made a search! ", term)
    }
    
    func didDismiss(controller: GiphyViewController?) {
    }

    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        giphyViewController.dismiss(animated: true, completion: { [weak self] in
            self?.addClipForMedia(media)
        })
    }
    
}
