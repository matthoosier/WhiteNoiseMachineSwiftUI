//
//  AppDelegate.swift
//  WhiteNoiseMachineSwiftUI
//
//  Created by Matt Hoosier on 10/20/22.
//

#if canImport(UIKit)
import AVFoundation
import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        } catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        return true
    }
}
#endif
