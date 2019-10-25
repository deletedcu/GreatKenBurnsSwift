//
//  ViewController.swift
//  KenBurnsProject
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    enum SegueIdentifier: String {
        case showKenBurns
    }
    
    private let medias = [Media(title: "One", description: "The first media.", image: "http://hdwpro.com/wp-content/uploads/2018/07/Awesome-Landscape-Wallpaper.jpg"),
                          Media(title: "Two", description: "The second media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
                          Media(title: "Three", description: "The third media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Cool-Lake-Wallpaper.jpg")]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier.flatMap(SegueIdentifier.init) else {
            return
        }
        
        switch identifier {
        case .showKenBurns:
            let kenBurnsVC = segue.destination as! KenBurnsViewController
            kenBurnsVC.inject(medias: medias, currentMediaIndex: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preloadIImage(data: self.medias, index: 0)
    }
    
    private func preloadIImage(data: [Media], index: Int) {
        NSLog("preloadImage index %d", index)
        if index >= data.count {
            return
        }
        let media = data[index]
        SDWebImageManager.shared.loadImage(with: URL(string: media.image)!, options: .highPriority, progress: nil) {[weak self] (image, data, err, cacheType, isFinished, url) in
            guard let sself = self else { return }
            sself.preloadIImage(data: sself.medias, index: index + 1)
        }
    }
}

