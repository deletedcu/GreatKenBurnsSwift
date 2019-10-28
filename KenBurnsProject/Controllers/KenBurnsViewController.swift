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
    
    // Pre-fetch image values
    private var lastNextIndex: Int! = 0
    private var lastPrevIndex: Int! = 0
    private let pageSize: Int! = 5
    
    let imageCache = NSCache<NSString, UIImage>()
    var imagesArray = [UIImage]()
    
    private var currentMedia: Media {
        medias[currentMediaIndex]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("viewDidLoad")
        controlsView.delegate = self
        preloadNextImages()
        preloadPrevImages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NSLog("viewDidAppear")
        updateUI(with: currentMedia)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        kenBurnsImageView.stopAnimating()
        super.viewDidDisappear(animated)
    }

    func inject(medias: [Media], currentMediaIndex: Int) {
        NSLog("inject")
        self.medias = medias
        if self.medias.count > pageSize {
            self.lastPrevIndex = self.medias.count - pageSize
        }
        self.currentMediaIndex = currentMediaIndex
        if currentMediaIndex == self.medias.count - 1 {
            self.lastNextIndex = 0
            self.lastPrevIndex = currentMediaIndex - 1
        } else if currentMediaIndex == 0 {
            self.lastNextIndex = currentMediaIndex + 1
            self.lastPrevIndex = self.medias.count - 1
        } else {
            self.lastNextIndex = currentMediaIndex + 1
            self.lastPrevIndex = currentMediaIndex - 1
        }
        
    }
    
    @IBAction func onBack(sender: UIButton!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func updateUI(with media: Media) {
        controlsView.configure(title: media.title, description: media.description)
        controlsView.isPaused = false
        kenBurnsImageView.stopAnimating()
        kenBurnsImageView.fetchImage(URL(string: media.image)!, placeholder: UIImage())
        kenBurnsImageView.zoomIntensity = 1.5
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
        DispatchQueue.global(qos: .background).async {
            if self.medias.count > self.lastNextIndex &&
                self.currentMediaIndex >= self.lastNextIndex - 3 {
                
                var urls = [URL]()
                if self.medias.count > self.lastNextIndex + self.pageSize {
                    let data = Array(self.medias[self.lastNextIndex ..< self.lastNextIndex + self.pageSize])
                    data.forEach { (media) in
                        if let url = URL(string: media.image) {
                            urls.append(url)
                        }
                    }
                    self.lastNextIndex += self.pageSize
                } else {
                    let data = Array(self.medias[self.lastNextIndex ..< self.medias.count])
                    data.forEach { (media) in
                        if let url = URL(string: media.image) {
                            urls.append(url)
                        }
                    }
                    self.lastNextIndex = self.medias.count
                }
                SDWebImagePrefetcher.shared.prefetchURLs(urls)
            } else if self.currentMediaIndex == self.medias.count - 2 {
                self.lastNextIndex = 0
            }

            NSLog("preloadNextImages lastIndex: %d", self.lastNextIndex)
        }
    }
    
    // Preload previous images when click backward button
    private func preloadPrevImages() {
        DispatchQueue.global(qos: .background).async {
            if self.medias.count > self.pageSize &&
                self.currentMediaIndex < self.lastPrevIndex + 3 {
                
                var urls = [URL]()
                if self.lastPrevIndex - self.pageSize > 0 {
                    let data = Array(self.medias[self.lastPrevIndex - self.pageSize ..< self.lastPrevIndex])
                    data.forEach { (media) in
                        if let url = URL(string: media.image) {
                            urls.append(url)
                        }
                    }
                    self.lastPrevIndex -= self.pageSize
                } else {
                    let data = Array(self.medias[0 ..< self.lastPrevIndex])
                    data.forEach { (media) in
                        if let url = URL(string: media.image) {
                            urls.append(url)
                        }
                    }
                    if self.currentMediaIndex == 1 {
                        self.lastPrevIndex = self.medias.count - 1
                    } else {
                        self.lastPrevIndex = 0
                    }
                }
                NSLog("preloadPrevImages lastIndex: %d", self.lastPrevIndex)
                SDWebImagePrefetcher.shared.prefetchURLs(urls)
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
