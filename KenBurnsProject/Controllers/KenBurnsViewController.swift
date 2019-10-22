//
//  KenBurnsViewController.swift
//  KenBurnsProject
//

import UIKit

class KenBurnsViewController: UIViewController {
    
    @IBOutlet private weak var controlsView: ControlsView!
    @IBOutlet weak var kenBurnsView: KenBurnsView!
    
    private var medias = [Media]()
    private var currentMediaIndex: Int!
    
    let imageCache = NSCache<NSString, UIImage>()
    var imagesArray = [UIImage]()
    
    private var currentMedia: Media {
        medias[currentMediaIndex]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        controlsView.delegate = self
        updateUI(with: currentMedia)
        
        kenBurnsView.kenBurnsDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadImages(self.medias, index: 0)
    }
    
    func loadImages(_ data: [Media], index: Int) {
        if index >= data.count { return }
        
        let media = data[index]
        self.downloadImage(url: URL(string: media.image)!) {[weak self] (image, err) in
            guard let sself = self else { return }
            if let image = image {
                sself.imagesArray.append(image)
                sself.kenBurnsView.addImage(image: image)
            } else {
                sself.imagesArray.append(UIImage(named: "1")!)
                sself.kenBurnsView.addImage(image: UIImage(named: "1")!)
            }
            
            if index == 0 {
                sself.kenBurnsView.animateWithImages(sself.imagesArray, imageAnimationDuration: 10, initialDelay: 0, shouldLoop: true)
            }
            
            sself.loadImages(data, index: index + 1)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        kenBurnsView.stopAnimation()
        
        super.viewDidDisappear(animated)
    }

    func inject(medias: [Media], currentMediaIndex: Int) {
        self.medias = medias
        self.currentMediaIndex = currentMediaIndex
    }
    
    private func updateUI(with media: Media) {
        controlsView.configure(title: media.title, description: media.description)
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
        
        if kenBurnsView.didAdvanceToNextImageIndex() {
            kenBurnsView.restartAnimation()
        }
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
        
        if kenBurnsView.didAdvanceToPrevImageIndex() {
            kenBurnsView.restartAnimation()
        }
    }
    
    private func toggleMedia(_ isPaused: Bool) {
        if (isPaused) {
            kenBurnsView.pauseAnimation()
        } else {
            kenBurnsView.resumeAnimation()
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            completion(cachedImage, nil)
        } else {
            URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
                if let error = error {
                    completion(nil, error)
                } else if let data = data {
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)!
                        self.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                        completion(image, nil)
                    }
                } else {
                    completion(nil, error)
                }
            }).resume()
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

// Mark: - KenBurnsViewDelegate
extension KenBurnsViewController: KenBurnsViewDelegate {
    func didShowImage(_ kenBurnsView: KenBurnsView, image: UIImage, atIndex: Int) {
        let media = medias[atIndex]
        updateUI(with: media)
        controlsView.isPaused = false
    }
    
    func didFinishedAllImages(_ kenBurnsView: KenBurnsView, images: Array<UIImage>) {
        
    }
}
