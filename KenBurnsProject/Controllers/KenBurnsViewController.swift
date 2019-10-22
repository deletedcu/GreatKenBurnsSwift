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
        
        
        
        let images: [UIImage] = [UIImage(named: "1")!, UIImage(named: "2")!, UIImage(named: "3")!]
        kenBurnsView.animateWithImages(images, imageAnimationDuration: 10, initialDelay: 0, shouldLoop: true)
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
}

// MARK: - ControlsViewDelegate

extension KenBurnsViewController: ControlsViewDelegate {
    func didTapPreviousButton() {
        playPreviousMedia()
    }
    
    func didTapNextButton() {
        playNextMedia()
    }
}

// Mark: - KenBurnsViewDelegate
extension KenBurnsViewController: KenBurnsViewDelegate {
    func didShowImage(_ kenBurnsView: KenBurnsView, image: UIImage, atIndex: Int) {
        
    }
    
    func didFinishedAllImages(_ kenBurnsView: KenBurnsView, images: Array<UIImage>) {
        
    }
}
