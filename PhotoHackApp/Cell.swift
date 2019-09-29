//
//  Cell.swift
//  PhotoHackApp
//
//  Created by Alex on 9/29/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit

protocol CellDelegate: class {
    func playTapped(at indexPath: IndexPath)
}

class Cell: UITableViewCell {

    var indexPath: IndexPath!
    weak var delegate: CellDelegate?
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
 
    @IBAction func play() {
        delegate?.playTapped(at: indexPath)
    }
    
    
    // MARK: - Effects
    
    var emitterLayer: CAEmitterLayer!
    var emojiCell: CAEmitterCell!
    
    var emoji: String?
    func startEmiting() {
        emitterLayer?.removeFromSuperlayer()
        
        emitterLayer = CAEmitterLayer()
        emojiCell = CAEmitterCell()
        
        emitterLayer.emitterSize = CGSize(width: containerView.bounds.width, height: 2)
        emitterLayer.emitterPosition = CGPoint(x: containerView.bounds.midX, y: containerView.bounds.maxY)
        emitterLayer.renderMode = .additive
        emitterLayer.emitterShape = .line
        
        emojiCell.contents = emoji?.image()?.cgImage
        emojiCell.lifetime = 5.0
        emojiCell.birthRate = 2
        emojiCell.alphaSpeed = 1.0
        emojiCell.velocity = 50
        emojiCell.velocityRange = 20
        emojiCell.emissionRange = CGFloat.pi
        
        emitterLayer.emitterCells = [emojiCell]
        containerView.layer.insertSublayer(emitterLayer, at: 0)
    }
    
}

extension String {
    func image() -> UIImage? {
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(CGRect(origin: .zero, size: size))
        (self as AnyObject).draw(in: rect, withAttributes: [.font: UIFont.systemFont(ofSize: 40)])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
