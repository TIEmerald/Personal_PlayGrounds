//
//  ProjectTwoContentView.swift
//  Personal_PlayGrounds
//
//  Created by UNDaniel on 9/3/20.
//  Copyright © 2020 UNDaniel. All rights reserved.
//

import Foundation
import UIKit

func loadMap() -> Tilemap {
    let url = Bundle.main.url(forResource: "map", withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return try! JSONDecoder().decode(Tilemap.self, from: data)
}


class ProjectTwoContentViewController: UIViewController {
    
    let imageView = UIImageView()
    let panRecognizer = UIPanGestureRecognizer()
    let joystickRadius = 40.0
    var world = World(player: Player(position: Vector(x: 2.5, y: 2.5), velocity: Vector(x: 0, y: 0)), map: loadMap())
    var previousTime: Double = CACurrentMediaTime()

    var joystickVector: Vector {
        let translation = panRecognizer.translation(in: view)
        let vector = Vector(x: Double(translation.x), y: Double(translation.y))
        let result = vector / max(joystickRadius, vector.length) // Added Limit to the jostick vector)
        panRecognizer.setTranslation(CGPoint(x: result.x * joystickRadius, y: result.y * joystickRadius), in: view)
        return result
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpImageView()
        view.addGestureRecognizer(panRecognizer)
        
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .main, forMode: .common)
    }
    
    @objc func update(_ displayLink: CADisplayLink) {
        var renderer = Renderer(width: 256, height: 256)
        let timestep = displayLink.timestamp - previousTime
        world.update(timestep: timestep, input: joystickVector)
        renderer.draw(world: world)
        previousTime = displayLink.timestamp
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
