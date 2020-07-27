//
//  SoundManager.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

import AVFoundation

class SoundManager: NSObject {
    
    static let shared = SoundManager()
    
    private var player: AVAudioPlayer?
    
    var isSoundEnabled: Bool {
        get {
            // Since UserDefaults.standard.bool(forKey: "sound") will default to "false" if it has not been set
            // You might want to use `object`, because if an object has not been set yet it will be nil
            // Then if it's nil you know it's the user's first time launching the app (provide default value of true)
            UserDefaults.standard.object(forKey: "sound") as? Bool ?? true
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "sound")
        }
    }
    
    func playSound() {
        do {
            let path = Bundle.main.path(forResource: "Jeopardy-theme-song.mp3", ofType: nil)!
            let url = URL(fileURLWithPath: path)
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
        } catch {
            print("Error could not load theme song!")
        }
    }
    
    func stopSound() {
        player?.stop()
    }
    
    func toggleSoundPreference() {
        isSoundEnabled.toggle()
        if isSoundEnabled {
            playSound()
        } else {
            stopSound()
        }
    }
    
}
