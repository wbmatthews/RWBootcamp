//
//  SoundManager.swift
//  jQuiz
//
//  Created by Jay Strawn on 7/17/20.
//  Copyright © 2020 Jay Strawn. All rights reserved.
//

//import Foundation
import AVFoundation

class SoundManager: NSObject {

    static let shared = SoundManager()

    private var player: AVAudioPlayer?

    var isSoundEnabled: Bool? {
        get {
          if let isSoundEnabled = UserDefaults.standard.object(forKey: "sound") as? Bool {
            return isSoundEnabled
          } else {
            return true
          }
        }
      
      set {
        if let enablingSound = newValue {
          if enablingSound {
            let path = Bundle.main.path(forResource: "Jeopardy-theme-song", ofType: "mp3")!
            let url = URL(fileURLWithPath: path)
            do {
              player = try AVAudioPlayer(contentsOf: url)
              UserDefaults.standard.set(true, forKey: "sound")
            } catch let error {
              print("Audio error: \(error)")
            }
          } else {
            player = nil
            UserDefaults.standard.set(false, forKey: "sound")
          }
        }
      }
  }

    func playSound() {
      if let player = player {
        if player.isPlaying {
          player.pause()
          player.currentTime = 0
        }
        player.play()
      }
    }

    func toggleSoundPreference() {
      if let _ = isSoundEnabled {
        self.isSoundEnabled!.toggle()
      } else {
        self.isSoundEnabled = false
      }
    }

}
