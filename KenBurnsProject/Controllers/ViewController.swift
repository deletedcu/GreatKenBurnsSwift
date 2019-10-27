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
    
    private var nextData = [Media]()
    private var prevData = [Media]()
    
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
}

