//
//  ControlsView.swift
//  KenBurnsProject
//

import UIKit

protocol ControlsViewDelegate: class {
    func didTapPreviousButton()
    func didTapNextButton()
}

@IBDesignable
class ControlsView: UIView, NibOwnerLoadable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    weak var delegate: ControlsViewDelegate?
    
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
}



