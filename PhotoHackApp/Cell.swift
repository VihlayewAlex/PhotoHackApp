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
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
 
    @IBAction func play() {
        delegate?.playTapped(at: indexPath)
    }
    
}
