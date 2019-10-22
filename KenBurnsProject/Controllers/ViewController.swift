//
//  ViewController.swift
//  KenBurnsProject
//

import UIKit

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
}

