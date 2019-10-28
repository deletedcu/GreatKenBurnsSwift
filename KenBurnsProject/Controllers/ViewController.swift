//
//  ViewController.swift
//  KenBurnsProject
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let itemsPerRow: CGFloat = 2
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                            left: 10.0,
                                            bottom: 10.0,
                                            right: 10.0)
    
    enum SegueIdentifier: String {
        case showKenBurns
    }
    
    private let medias = [
        Media(title: "1", description: "The 1 media.", image: "http://hdwpro.com/wp-content/uploads/2018/07/Awesome-Landscape-Wallpaper.jpg"),
        Media(title: "2", description: "The 2 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
        Media(title: "3", description: "The 3 media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Cool-Lake-Wallpaper.jpg"),
        Media(title: "4", description: "The 4 media.", image: "http://hdwpro.com/wp-content/uploads/2018/07/Awesome-Landscape-Wallpaper.jpg"),
        Media(title: "5", description: "The 5 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
        Media(title: "6", description: "The 6 media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Cool-Lake-Wallpaper.jpg"),
        Media(title: "7", description: "The 7 media.", image: "http://hdwpro.com/wp-content/uploads/2018/07/Awesome-Landscape-Wallpaper.jpg"),
        Media(title: "8", description: "The 8 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
        Media(title: "9", description: "The 9 media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Cool-Lake-Wallpaper.jpg"),
        Media(title: "10", description: "The 10 media.", image: "http://hdwpro.com/wp-content/uploads/2018/07/Awesome-Landscape-Wallpaper.jpg"),
        Media(title: "11", description: "The 11 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
        Media(title: "12", description: "The 12 media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Cool-Lake-Wallpaper.jpg"),
        Media(title: "13", description: "The 13 media.", image: "http://hdwpro.com/wp-content/uploads/2018/07/Awesome-Landscape-Wallpaper.jpg"),
        Media(title: "14", description: "The 14 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
        Media(title: "15", description: "The 15 media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Cool-Lake-Wallpaper.jpg"),
        Media(title: "16", description: "The 16 media.", image: "http://hdwpro.com/wp-content/uploads/2018/07/Awesome-Landscape-Wallpaper.jpg"),
        Media(title: "17", description: "The 17 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
        Media(title: "18", description: "The 18 media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Cool-Lake-Wallpaper.jpg"),
        Media(title: "19", description: "The 19 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
        Media(title: "20", description: "The 20 media.", image: "http://hdwpro.com/wp-content/uploads/2018/07/Awesome-Landscape-Wallpaper.jpg"),
        Media(title: "21", description: "The 21 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
        Media(title: "22", description: "The 22 media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Cool-Lake-Wallpaper.jpg"),
        Media(title: "23", description: "The 23 media.", image: "http://hdwpro.com/wp-content/uploads/2018/07/Awesome-Landscape-Wallpaper.jpg"),
        Media(title: "24", description: "The 24 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
        Media(title: "25", description: "The 25 media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Cool-Lake-Wallpaper.jpg"),
        Media(title: "26", description: "The 26 media.", image: "http://hdwpro.com/wp-content/uploads/2018/07/Awesome-Landscape-Wallpaper.jpg"),
        Media(title: "27", description: "The 27 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg"),
        Media(title: "28", description: "The 28 media.", image: "http://hdwpro.com/wp-content/uploads/2019/09/Cool-Lake-Wallpaper.jpg"),
        Media(title: "29", description: "The 29 media.", image: "http://hdwpro.com/wp-content/uploads/2019/10/Natural-Ultra-HD-Wallpaper.jpg")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.stopAnimating()
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let media = self.medias[indexPath.row]
        
        let url = URL(string: media.image)!
        let cacheKey = SDWebImageManager.shared.cacheKey(for: url)
        SDWebImageManager.shared.imageCache.containsImage(forKey: cacheKey, cacheType: .all) { (cacheType) in
            if cacheType == .none {
                self.activityIndicator.startAnimating()
                SDWebImagePrefetcher.shared.prefetchURLs([URL(string: media.image)!],
                    progress: { (finishedUrlsCount, totalUrlsCount) in
                        NSLog("progress %d / %d", finishedUrlsCount, totalUrlsCount)
                    }) { (_, _) in
                        self.activityIndicator.stopAnimating()
                        self.performSegue(withIdentifier: "showKenBurns", sender: indexPath.row)
                    }
            } else {
                self.performSegue(withIdentifier: "showKenBurns", sender: indexPath.row)
            }
        }
        
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
        
        return CGSize(width: widthPerItem, height: widthPerItem)
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
