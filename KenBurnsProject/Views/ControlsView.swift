//
//  ControlsView.swift
//  KenBurnsProject
//

import UIKit

protocol ControlsViewDelegate: class {
    func didTapPreviousButton()
    func didTapNextButton()
    func didPlayPauseButton(_ isPaused: Bool)
}

@IBDesignable
class ControlsView: UIView, NibOwnerLoadable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet public weak var backwardButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    @IBOutlet private weak var toggleButton: UIButton!
    
    weak var delegate: ControlsViewDelegate?
    var isPaused: Bool = false {
        didSet {
            if #available(iOS 13.0, *) {
                toggleButton.setImage(UIImage(systemName: isPaused ? "play" : "pause"), for: .normal)
            } else {
                toggleButton.setImage(UIImage(named: isPaused ? "icon-play" : "icon-pause"), for: .normal)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        loadNibContent()
        
        if #available(iOS 13.0, *) {
            backwardButton.setImage(UIImage(systemName: "backward.end"), for: .normal)
            forwardButton.setImage(UIImage(systemName: "forward.end"), for: .normal)
            toggleButton.setImage(UIImage(systemName: "pause"), for: .normal)
        } else {
            // Fallback on earlier versions
            backwardButton.setImage(UIImage(named: "icon-backward"), for: .normal)
            forwardButton.setImage(UIImage(named: "icon-forward"), for: .normal)
            toggleButton.setImage(UIImage(named: "icon-pause"), for: .normal)
        }
    }
    
    func configure(title: String, description: String) {
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    @IBAction func didTapPreviousButton(_ sender: UIButton) {
        delegate?.didTapPreviousButton()
    }
    
    @IBAction func didTapNextButton(_ sender: UIButton) {
        delegate?.didTapNextButton()
    }
    
    @IBAction func didPlayPauseButton(_ sender: UIButton) {
        if (isPaused) {
            isPaused = false
        } else {
            isPaused = true
        }
        delegate?.didPlayPauseButton(isPaused)
    }
}



