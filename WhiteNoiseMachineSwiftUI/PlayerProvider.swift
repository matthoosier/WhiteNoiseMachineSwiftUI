//
//  PlayerProvider.swift
//  White Noise Machine
//
//  Created by Matt Hoosier on 3/28/22.
//

import Foundation
import AVFoundation

class PlayerProvider {
    
    var player: AVPlayer {
        get {
            return avQueuePlayer
        }
    }
    
    private var avQueuePlayer: AVQueuePlayer
    private var avPlayerLooper: AVPlayerLooper?
    
    init() {
        avQueuePlayer = AVQueuePlayer()
        
        let resourceName = "mc2method.org-03-White-Noise-10min"
        //let resourceName = "ding"

        guard let audioFileUrl = Bundle.main.url(forResource: resourceName, withExtension: "mp3") else {
            print("Couldn't resolve bundle URL for resource \(resourceName)")
            return
        }

        avPlayerLooper = AVPlayerLooper(player: avQueuePlayer, templateItem: AVPlayerItem(asset: AVAsset(url: audioFileUrl)))
        avQueuePlayer.allowsExternalPlayback = true
    }
}
