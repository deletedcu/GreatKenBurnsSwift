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
    private var currentMediaIndex: Int! = 0
    
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
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        updateUI(with: currentMedia)
//    }
    
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
        kenBurnsImageView.fetchImage(URL(string: media.image)!, placeholder: UIImage(named: "placeholder"))
        kenBurnsImageView.zoomIntensity = 1.2
        kenBurnsImageView.setDuration(min: 6, max: 10)
        kenBurnsImageView.isFirstRun = true
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
