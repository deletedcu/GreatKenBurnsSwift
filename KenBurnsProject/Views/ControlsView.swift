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
    @IBOutlet private weak var toggleButton: UIButton!
    
    weak var delegate: ControlsViewDelegate?
    var isPaused: Bool = false
    
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



