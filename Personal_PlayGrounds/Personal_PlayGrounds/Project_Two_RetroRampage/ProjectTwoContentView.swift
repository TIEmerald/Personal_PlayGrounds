//
//  ProjectTwoContentView.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 9/3/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import Foundation
import UIKit

struct PTwoColor {
    var r, g, b: UInt8
    var a: UInt8 = 255
}

extension PTwoColor {
    static let clear = PTwoColor(r: 0, g: 0, b: 0, a: 0)
    static let black = PTwoColor(r: 0, g: 0, b: 0)
    static let white = PTwoColor(r: 255, g: 255, b: 255)
    static let gray = PTwoColor(r: 192, g: 192, b: 192)
    static let red = PTwoColor(r: 255, g: 0, b: 0)
    static let green = PTwoColor(r: 0, g: 255, b: 0)
    static let blue = PTwoColor(r: 0, g: 0, b: 255)
}

struct Bitmap {
    let width: Int
    var pixels: [PTwoColor]
    
    var height: Int {
        pixels.count / width
    }
    
    init(width: Int, height: Int, color: PTwoColor) {
        self.width = width
        pixels = Array(repeating: color, count: width * height)
    }
    
    subscript(x: Int, y: Int) -> PTwoColor {
        get { pixels[y * width + x] }
        set { pixels[y * width + x] = newValue }
    }
}

struct Renderer {
    var bitmap = Bitmap(width: 8, height: 8, color: .white)
    
    mutating func draw(x: Int) {
        bitmap[x, 0] = PTwoColor.blue
    }
}

class ProjectTwoContentViewController: UIViewController {
    let imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageView()
        
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .main, forMode: .common)
    }
    
    @objc func update(_ displayLink: CADisplayLink) {
        let x = Int(displayLink.timestamp) % 8
        var renderer = Renderer()
        renderer.draw(x: x)
        imageView.image = UIImage(bitmap: renderer.bitmap)
    }
}

extension ProjectTwoContentViewController {
    func setUpImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.layer.magnificationFilter = .nearest
    }
}

extension UIImage {
    convenience init?(bitmap: Bitmap) {
        let alphaInfo = CGImageAlphaInfo.premultipliedLast
        let bytesPerPixel = MemoryLayout<PTwoColor>.stride
        let bytesPerRow = bitmap.width * bytesPerPixel
        
        guard let providerRef = CGDataProvider(data: Data(bytes: bitmap.pixels, count: bitmap.height * bytesPerRow) as CFData) else {
            return nil
        }
        
        guard let cgImage = CGImage(
            width: bitmap.width,
            height: bitmap.height,
            bitsPerComponent: 8,
            bitsPerPixel: bytesPerPixel * 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: alphaInfo.rawValue),
            provider: providerRef,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
            ) else {
                return nil
        }
        
        self.init(cgImage: cgImage)
    }
}
