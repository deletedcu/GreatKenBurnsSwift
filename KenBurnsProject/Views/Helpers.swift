//
//  Helpers.swift
//  KenBurnsProject
//
//  Created by King on 2019/10/23.
//  Copyright © 2019 Sample. All rights reserved.
//

import UIKit
import ImageIO

extension UIView {
    var x: CGFloat {
        get {
            return self.frame.origin.x
        } set {
            self.frame = CGRect (x: newValue, y: self.y, width: self.w, height: self.h)
        }
    }
    
    var y: CGFloat {
        get {
            return self.frame.origin.y
        } set {
            self.frame = CGRect (x: self.x, y: newValue, width: self.w, height: self.h)
        }
    }
    
    var w: CGFloat {
        get {
            return self.frame.size.width
        } set {
            self.frame = CGRect (x: self.x, y: self.y, width: newValue, height: self.h)
        }
    }
    
    var h: CGFloat {
        get {
            return self.frame.size.height
        } set {
            self.frame = CGRect (x: self.x, y: self.y, width: self.w, height: newValue)
        }
    }
    
    
    var left: CGFloat {
        get {
            return self.x
        } set {
            self.x = newValue
        }
    }
    
    var right: CGFloat {
        get {
            return self.x + self.w
        } set {
            self.x = newValue - self.w
        }
    }
    
    var top: CGFloat {
        get {
            return self.y
        } set {
            self.y = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.y + self.h
        } set {
            self.y = newValue - self.h
        }
    }
    
    var position: CGPoint {
        get {
            return self.frame.origin
        } set {
            self.frame = CGRect (origin: newValue, size: self.frame.size)
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set {
            self.frame = CGRect (origin: self.frame.origin, size: newValue)
        }
    }
}

extension Array where Element : Equatable {
    mutating func remove(_ object : Element) {
        if let index = self.firstIndex(of: object) {
            self.remove(at: index)
        }
    }
}

class Random {
    class func probability(_ p: Float) -> Bool {
        return floatNorm() < p
    }

    class func floatNorm() -> Float {
        return Float(arc4random()) / Float(UINT32_MAX)
    }

    class func float(_ min: Float, _ max: Float) -> Float {
        return floatNorm() * (max - min) + min
    }

    class func double(_ min: Double, _ max: Double) -> Double {
        return Double(float(Float(min), Float(max)))
    }

    class func int(_ min: Int, _ max: Int) -> Int {
        let range: UInt32 = UInt32(max - min)
        return Int(arc4random_uniform(range)) + min
    }
}

extension UIImageView {
    /// Adds image fade animation support for SDWebImage.
    ///
    /// The image always fades in regardless if it is already in the cache.
    func sd_setImageWithFadeAlways(with url: URL?, placeholderImage placeholder: UIImage? = nil) {
        self.sd_setImage(with: url) { image, _, _, _ in
            if let image = image {
                UIView.transition(with: self, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.image = image
                }, completion: nil)
            } else {
                // Error - use placeholder.
                self.image = placeholder
            }
        }
    }
}

extension UIImage {
    // Create thumbnail from image
//    func getThumbnail() -> UIImage? {
//        guard let imageData = self.pngData() else {
//            return nil
//        }
//
//        let options = [
//            kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
//            kCGImageSourceCreateThumbnailWithTransform: true,
//            kCGImageSourceShouldCacheImmediately: true,
//            kCGImageSourceThumbnailMaxPixelSize: 300
//        ] as CFDictionary
//
//        guard let source = CGImageSourceCreateWithData(imageData as CFData, nil),
//            let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options) else {
//            return nil
//        }
//
//        return UIImage(cgImage: imageReference)
//    }
    
    func getThumbnail(ratio: CGFloat) -> UIImage {
        return self.crop(ratio: ratio).resize(toTargetSize: CGSize(width: 200, height: 200))
    }
    
    func crop(ratio: CGFloat) -> UIImage {
        let originalWidth  = self.size.width
        let originalHeight = self.size.height
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        var newWidth: CGFloat = 0.0
        var newHeight: CGFloat = 0.0
        
        if (originalWidth / ratio > originalHeight) {
            // landscape
            newHeight = originalHeight
            newWidth = originalHeight / ratio
            x = (originalWidth - newWidth) / 2.0
            y = 0.0
        } else {
            // portrait
            newWidth = originalWidth
            newHeight = originalWidth * ratio
            x = 0.0
            y = (originalHeight - newHeight) / 2.0
        }
        
        let cropSquare = CGRect(x: x, y: y, width: newWidth, height: newHeight)
        let imageRef = self.cgImage!.cropping(to: cropSquare);
        
        return UIImage(cgImage: imageRef!, scale: UIScreen.main.scale, orientation: self.imageOrientation)
    }
    
    func resize(toTargetSize targetSize: CGSize) -> UIImage {
        // inspired by Hamptin Catlin
        // https://gist.github.com/licvido/55d12a8eb76a8103c753

        let newScale = self.scale // change this if you want the output image to have a different scale
        let originalSize = self.size

        let widthRatio = targetSize.width / originalSize.width
        let heightRatio = targetSize.height / originalSize.height

        // Figure out what our orientation is, and use that to form the rectangle
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: floor(originalSize.width * heightRatio), height: floor(originalSize.height * heightRatio))
        } else {
            newSize = CGSize(width: floor(originalSize.width * widthRatio), height: floor(originalSize.height * widthRatio))
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)

        // Actually do the resizing to the rect using the ImageContext stuff
        let format = UIGraphicsImageRendererFormat()
        format.scale = newScale
        format.opaque = true
        let newImage = UIGraphicsImageRenderer(bounds: rect, format: format).image() { _ in
            self.draw(in: rect)
        }

        return newImage
    }
}
