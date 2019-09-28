//
//  SoundPlayer.swift
//  PhotoHackApp
//
//  Created by Yaroslav Zarechnyy on 9/28/19.
//  Copyright © 2019 Alex. All rights reserved.
//

import Foundation
import AVFoundation

class SoundPlayerService {
    
    var player: AVPlayer?
    
    func play(_ url: String) {
        //https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
        let stringURL = url
        let playerItem = AVPlayerItem( url:NSURL( string:url )! as URL )
        player = AVPlayer(playerItem:playerItem)
        player!.rate = 1.0;
        player!.play()
    }
    
    func stop() {
        //https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3
//        let stringURL = url
//        let playerItem = AVPlayerItem( url:NSURL( string:url )! as URL )
//        player = AVPlayer(playerItem:playerItem)
        player!.rate = 1.0;
        player!.pause()
    }
}
