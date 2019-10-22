//
//  NibOwnerLoadable.swift
//  KenBurnsProject
//

import UIKit

// MARK: - Protocol Definition

/// Make your UIView subclasses conform to this protocol when:
///  * They are NIB-based
///  * This class is used as the XIB's File's Owner
///
/// This will instantiate your UIView subclass from the NIB in a type-safe manner.
public protocol NibOwnerLoadable: class {
    
    /// The nib file to use to load a new instance of the View designed in a XIB.
    static var nib: UINib { get }
}

// MARK: - Default Implementation

public extension NibOwnerLoadable {
    
    /// By default, use the nib which has the same name as the name of the class,
    /// and located in the bundle of that class.
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
}

// MARK: - Support for instantiation from NIB

public extension NibOwnerLoadable where Self: UIView {
    
    // Adds content loaded from the nib and adds constraints automatically.
    func loadNibContent() {
        guard let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
}
