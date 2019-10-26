//
//  KenBurnsViewController.swift
//  KenBurnsProject
//

import UIKit
import SDWebImage

class KenBurnsViewController: UIViewController {
    
    @IBOutlet private weak var controlsView: ControlsView!
    @IBOutlet weak var kenBurnsImageView: KenBurnsImageView!
    
    private var medias = [Media]()
    private var tempData = [Media]()
    private var currentMediaIndex: Int! = 0
    
    // Pre-fetch image values
    private var lastIndex: Int! = 5
    private let pageSize: Int! = 5
    
    let imageCache = NSCache<NSString, UIImage>()
    var imagesArray = [UIImage]()
    
    private var currentMedia: Media {
        medias[currentMediaIndex]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        controlsView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateUI(with: currentMedia)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        kenBurnsImageView.stopAnimating()
        super.viewDidDisappear(animated)
    }

    func inject(medias: [Media], currentMediaIndex: Int) {
        self.medias = medias
        self.currentMediaIndex = currentMediaIndex
    }
    
    private func updateUI(with media: Media) {
        controlsView.configure(title: media.title, description: media.description)
        controlsView.isPaused = false
        kenBurnsImageView.stopAnimating()
        kenBurnsImageView.fetchImage(URL(string: media.image)!, placeholder: UIImage())
        kenBurnsImageView.zoomIntensity = 1.2
        kenBurnsImageView.loops = true
        kenBurnsImageView.pansAcross = true
        kenBurnsImageView.setDuration(min: 6, max: 10)
        kenBurnsImageView.startAnimating()
    }
    
    private func playNextMedia() {
        guard medias.count > 1 else {
            return
        }
        
        if (currentMediaIndex + 1) >= medias.count {
            currentMediaIndex = 0
        } else {
            currentMediaIndex = currentMediaIndex + 1
        }
        
        updateUI(with: currentMedia)
        preloadImages()
    }
    
    private func playPreviousMedia() {
        guard medias.count > 1 else {
            return
        }
        
        if (currentMediaIndex - 1) < 0 {
            currentMediaIndex = (medias.count - 1) < 0 ? 0 : (medias.count - 1)
        } else {
            currentMediaIndex = currentMediaIndex - 1
        }
        
        updateUI(with: currentMedia)
    }
    
    private func toggleMedia(_ isPaused: Bool) {
        if (isPaused) {
            kenBurnsImageView.pause()
        } else {
            kenBurnsImageView.resume()
        }
    }
    
    private func preloadImages() {
        if self.medias.count > self.lastIndex && self.currentMediaIndex >= self.lastIndex - 3 {
            if self.medias.count > self.lastIndex + self.pageSize {
                tempData = Array(self.medias[self.lastIndex ..< self.lastIndex + self.pageSize])
                self.lastIndex += self.pageSize
            } else {
                tempData = Array(self.medias[self.lastIndex ..< self.medias.count])
                self.lastIndex = self.medias.count
            }
            NSLog("preloadImages lastIndex: %d", self.lastIndex)
            self.preloadImage(data: tempData, index: 0)
        }
    }
    
    private func preloadImage(data: [Media], index: Int) {
        if index >= data.count {
            return
        }
        NSLog("preloadImage index: %d", index)
        let media = data[index]
        SDWebImageManager.shared.loadImage(with: URL(string: media.image)!, options: .highPriority, progress: nil) {[weak self] (image, data, err, cacheType, isFinished, url) in
            guard let sself = self else { return }
            sself.preloadImage(data: sself.tempData, index: index + 1)
        }
    }
    
}

// MARK: - ControlsViewDelegate

extension KenBurnsViewController: ControlsViewDelegate {
    func didTapPreviousButton() {
        playPreviousMedia()
    }
    
    func didTapNextButton() {
        playNextMedia()
    }
    
    func didPlayPauseButton(_ isPaused: Bool) {
        toggleMedia(isPaused)
    }
}
