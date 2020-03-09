//
//  ProjectTwoContentView.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 9/3/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import Foundation
import UIKit

class ProjectTwoContentViewController: UIViewController {
    
    let imageView = UIImageView()
    var player: Player = Player(
        position: Vector(x: 4, y: 4),
        velocity: Vector(x: 1, y: 1)
    )
    var previousTime: Double = CACurrentMediaTime()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageView()
        
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .main, forMode: .common)
    }
    
    @objc func update(_ displayLink: CADisplayLink) {
        var renderer = Renderer(width: 256, height: 256)
        let timestep = displayLink.timestamp - previousTime
        player.update(timestep: timestep)
        previousTime = displayLink.timestamp
        renderer.draw(player: player)
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
