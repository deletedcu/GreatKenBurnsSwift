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
    private var nextData = [Media]()
    private var prevData = [Media]()
    private var currentMediaIndex: Int! = 0
    
    private var isLoadAll: Bool! = false
    
    // Pre-fetch image values
    private var lastNextIndex: Int! = 5
    private var lastPrevIndex: Int! = 0
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
        if self.medias.count > pageSize {
            self.lastPrevIndex = self.medias.count - pageSize
        }
        self.currentMediaIndex = currentMediaIndex
    }
    
    private func updateUI(with media: Media) {
        controlsView.configure(title: media.title, description: media.description)
        controlsView.isPaused = false
        kenBurnsImageView.stopAnimating()
        kenBurnsImageView.fetchImage(URL(string: media.image)!, placeholder: UIImage())
        kenBurnsImageView.zoomIntensity = 0.5
        kenBurnsImageView.loops = true
        kenBurnsImageView.pansAcross = true
        kenBurnsImageView.setDuration(min: 20, max: 20)
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
        preloadNextImages()
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
        preloadPrevImages()
    }
    
    private func toggleMedia(_ isPaused: Bool) {
        if (isPaused) {
            kenBurnsImageView.pause()
        } else {
            kenBurnsImageView.resume()
        }
    }
    
    // Preload next images when click forward button
    private func preloadNextImages() {
        if self.medias.count > self.lastNextIndex &&
            self.currentMediaIndex >= self.lastNextIndex - 3 &&
            self.currentMediaIndex < self.lastPrevIndex &&
            self.lastPrevIndex > self.lastNextIndex {
            
            if self.medias.count > self.lastNextIndex + self.pageSize {
                nextData = Array(self.medias[self.lastNextIndex ..< self.lastNextIndex + self.pageSize])
                self.lastNextIndex += self.pageSize
            } else {
                nextData = Array(self.medias[self.lastNextIndex ..< self.medias.count])
                self.lastNextIndex = self.medias.count
                self.isLoadAll = true
            }
            NSLog("preloadNextImages lastIndex: %d", self.lastNextIndex)
            self.preloadImage(data: nextData, index: 0, isNext: true)
        }
    }
    
    // Preload previous images when click backward button
    private func preloadPrevImages() {
        if self.medias.count > self.pageSize &&
            self.currentMediaIndex < self.lastPrevIndex + 3 &&
            self.currentMediaIndex > self.lastNextIndex &&
            self.lastPrevIndex > self.lastNextIndex {
            
            if self.lastPrevIndex - self.pageSize > 0 {
                prevData = Array(self.medias[self.lastPrevIndex - self.pageSize ..< self.lastPrevIndex])
                self.lastPrevIndex -= self.pageSize
            } else {
                prevData = Array(self.medias[0 ..< self.lastPrevIndex])
                self.lastPrevIndex = 0
            }
            NSLog("preloadPrevImages lastIndex: %d", self.lastPrevIndex)
            self.preloadImage(data: prevData, index: prevData.count - 1,isNext: false)
        }
    }
    
    
    // Preload image while loop
    private func preloadImage(data: [Media], index: Int, isNext: Bool) {
        if index >= data.count || index < 0 {
            return
        }
        NSLog("preloadImage index: %d", index)
        let media = data[index]
        SDWebImageManager.shared.loadImage(with: URL(string: media.image)!, options: .highPriority, progress: nil) {[weak self] (image, d, err, cacheType, isFinished, url) in
            guard let sself = self else { return }
            if isNext {
                sself.preloadImage(data: data, index: index + 1, isNext: isNext)
            } else {
                sself.preloadImage(data: data, index: index - 1, isNext: isNext)
            }
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
