//
//  ViewController.swift
//  KenBurnsProject
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let itemsPerRow: CGFloat = 2
    
    let imageCache = NSCache<NSString, UIImage>()
    
    private let sectionInsets = UIEdgeInsets(top: 20.0,
                                            left: 20.0,
                                            bottom: 20.0,
                                            right: 20.0)
    
    enum SegueIdentifier: String {
        case showKenBurns
    }
    
    private let medias = [
        Media(title: "1", description: "The 1 media.", image: "https://assets.calm.com/2250x3654/80d12b2f75b6b88dd3a02be627a4e239.jpeg"),
        Media(title: "2", description: "The 2 media.", image: "https://assets.calm.com/2250x3654/b913e45bd43909c91eb3a810a4a07a97.jpeg"),
        Media(title: "3", description: "The 3 media.", image: "https://assets.calm.com/2250x3654/3eff6f2d733909bad8617d1c059f87ef.jpeg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCache.countLimit = 10
        collectionView.register(UINib(nibName: "\(ItemViewCell.self)", bundle: Bundle.main), forCellWithReuseIdentifier: ItemViewCell.reuseIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier.flatMap(SegueIdentifier.init) else {
            return
        }
        
        switch identifier {
        case .showKenBurns:
            let kenBurnsVC = segue.destination as! KenBurnsViewController
            if let index = sender as? Int {
                kenBurnsVC.inject(medias: medias, currentMediaIndex: index)
            } else {
                kenBurnsVC.inject(medias: medias, currentMediaIndex: 0)
            }
            
        }
    }
    
    func downloadImage(url: URL, completion: @escaping (_ image: UIImage? , _ error: Error?) -> Void) {
        DispatchQueue(label: "resize").async {
            if let cachedImage = self.imageCache.object(forKey: url.absoluteString as NSString) {
                DispatchQueue.main.async {
                    completion(cachedImage, nil)
                }
            } else {
                AppDelegate.imageManager.loadImage(with: url, options: [.continueInBackground, .scaleDownLargeImages, .retryFailed], progress: nil) { (image, data, err, cacheType, state, rrr) in
                    DispatchQueue(label: "resize").async {
                        if let img = image {
                            let thumbnail = img.getThumbnail(ratio: 1.2)
                            self.saveThumbnailAndLoad(url: url, thumbnail: thumbnail, completion: completion)
                            
                        } else {
                            DispatchQueue.main.async {
                                 completion(nil, err)
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    func saveThumbnailAndLoad(url: URL, thumbnail: UIImage, completion: @escaping (_ image: UIImage? , _ error: Error?) -> Void) {
        self.imageCache.setObject(thumbnail, forKey: url.absoluteString as NSString)
        DispatchQueue.main.async {
            completion(thumbnail, nil)
        }
    }
    
}

// MARK: - Collection View Data Source
extension ViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemViewCell.reuseIdentifier, for: indexPath) as! ItemViewCell
        let media = self.medias[indexPath.row]
        cell.configure(media: media)
        cell.imageView.image = nil
        if let url = URL(string: media.image) {
            self.downloadImage(url: url) { (image, error) in
                if let img = image {
                    if let cell = collectionView.cellForItem(at: indexPath)  as? ItemViewCell {
                        cell.imageView.image = img
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showKenBurns", sender: indexPath.row)
    }
    
}

// MARK: - Collection View Flow Layout Delegate
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
