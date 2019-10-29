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
        Media(title: "1", description: "The 1 media.", image: "http://hdwpro.com/wp-content/uploads/2018/07/Awesome-Landscape-Wallpaper.jpg"),
        Media(title: "2", description: "The 2 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
        Media(title: "3", description: "The 3 media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Cool-Lake-Wallpaper.jpg"),
        Media(title: "4", description: "The 4 media.", image: "http://hdwpro.com/wp-content/uploads/2019/01/Super-Desktop-Wallpaper.jpg"),
        Media(title: "5", description: "The 5 media.", image: "http://hdwpro.com/wp-content/uploads/2016/04/Wonderful-Life.jpeg"),
        Media(title: "6", description: "The 6 media.", image: "http://hdwpro.com/wp-content/uploads/2016/04/Wonderful-Worl.jpeg"),
        Media(title: "7", description: "The 7 media.", image: "http://hdwpro.com/wp-content/uploads/2016/04/Wonderful-Picture.jpeg"),
        Media(title: "8", description: "The 8 media.", image: "http://hdwpro.com/wp-content/uploads/2016/12/Top-HD-Pic.jpg"),
        Media(title: "9", description: "The 9 media.", image: "http://hdwpro.com/wp-content/uploads/2017/09/Free-Hawaii-Wallpaper.jpeg"),
        Media(title: "10", description: "The 10 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-MAC-Wallpaper.jpeg"),
        Media(title: "11", description: "The 11 media.", image: "http://hdwpro.com/wp-content/uploads/2017/02/Amazing-HD-Sunset-Picture.jpg"),
        Media(title: "12", description: "The 12 media.", image: "http://hdwpro.com/wp-content/uploads/2019/05/Top-Lake-Image.jpeg"),
        Media(title: "13", description: "The 13 media.", image: "http://hdwpro.com/wp-content/uploads/2016/07/Castle-Digital-Art.jpg"),
        Media(title: "14", description: "The 14 media.", image: "http://hdwpro.com/wp-content/uploads/2018/10/Floral-Digital-Wallpaper.jpg"),
        Media(title: "15", description: "The 15 media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Awesome-Grass-Wallpaper.jpg"),
        Media(title: "16", description: "The 16 media.", image: "http://hdwpro.com/wp-content/uploads/2018/09/Floral-Best-Wallpaper.jpg"),
        Media(title: "17", description: "The 17 media.", image: "http://hdwpro.com/wp-content/uploads/2019/02/nature-image.jpeg"),
        Media(title: "18", description: "The 18 media.", image: "http://hdwpro.com/wp-content/uploads/2017/09/Top-Falcon-Wallpaper.jpg"),
        Media(title: "19", description: "The 19 media.", image: "http://hdwpro.com/wp-content/uploads/2018/05/Super-1080p.jpg"),
        Media(title: "20", description: "The 20 media.", image: "http://hdwpro.com/wp-content/uploads/2019/01/Landscape-Wallpaper-HD-1080p.jpg"),
        Media(title: "21", description: "The 21 media.", image: "http://hdwpro.com/wp-content/uploads/2019/03/HD-Bugatti-La-Voiture-Noire.jpg"),
        Media(title: "22", description: "The 22 media.", image: "http://hdwpro.com/wp-content/uploads/2017/10/Beautiful-Ocean-Wallpaper.jpg"),
        Media(title: "23", description: "The 23 media.", image: "http://hdwpro.com/wp-content/uploads/2016/10/Mid-Season-Gardening.jpg"),
        Media(title: "24", description: "The 24 media.", image: "http://hdwpro.com/wp-content/uploads/2019/08/Nice-Bamboo-Wallpaper.jpg"),
        Media(title: "25", description: "The 25 media.", image: "http://hdwpro.com/wp-content/uploads/2015/12/nature.jpg"),
        Media(title: "26", description: "The 26 media.", image: "http://hdwpro.com/wp-content/uploads/2019/02/Beautiful-Nature.jpg"),
        Media(title: "27", description: "The 27 media.", image: "http://hdwpro.com/wp-content/uploads/2017/11/Nice-Snow-Wallpaper.jpg")]
    
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
                AppDelegate.imageManager.loadImage(with: url, options: [.continueInBackground, .lowPriority, .highPriority], progress: nil) { (image, data, err, cacheType, state, rrr) in
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
        cell.imageView.size = cell.size
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
