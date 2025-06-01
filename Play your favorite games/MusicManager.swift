//
//  MusicManager.swift
//  Potawatomi tribe game
//
//  Created by Mac on 13.05.2025.
//


import Foundation
import AVFoundation

class MusicManager: ObservableObject {
    static let shared = MusicManager()
    
    @Published var audioPlayerVolume: Float = 0.3
    @Published var paused: Bool = false
    @Published var soundsOn = false
    @Published var musicOn = true
    @Published var vibroOn = false
    
    var audioPlayer: AVAudioPlayer?
    
    private init() {
        // Загружаем сохраненные настройки при инициализации
        loadSettings()
    }
    
    // MARK: - Music Methods
    func playBackgroundMusic() {
        guard musicOn else { return }
        
        guard let url = Bundle.main.url(forResource: "level-iv-339695 (mp3cut.net)", withExtension: "mp3") else {
            print("Music file not found.")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = audioPlayerVolume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            paused = false
        } catch {
            print("Error playing music: \(error.localizedDescription)")
        }
    }
    
    func stopMusic() {
        audioPlayer?.stop()
        paused = true
    }
    
    func pauseMusic() {
        audioPlayer?.pause()
        paused = true
    }
    
    func resumeMusic() {
        guard musicOn else { return }
        audioPlayer?.play()
        paused = false
    }
    
    func toggleMusic() {
        musicOn.toggle()
        if musicOn {
            playBackgroundMusic()
        } else {
            pauseMusic()
        }
        saveSettings()
    }
    
    // MARK: - Sound Methods
    func playSoundEffect(name: String) {
        guard soundsOn else { return }
        
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else {
            print("Sound file \(name) not found.")
            return
        }
        
        do {
            let soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer.volume = audioPlayerVolume
            soundPlayer.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
    
    func toggleSounds() {
        soundsOn.toggle()
        saveSettings()
    }
    
    
    // MARK: - Settings Persistence
    private func saveSettings() {
        UserDefaults.standard.set(musicOn, forKey: "musicEnabled")
        UserDefaults.standard.set(soundsOn, forKey: "soundsEnabled")
        UserDefaults.standard.set(vibroOn, forKey: "vibrationEnabled")
    }
    
    private func loadSettings() {
        musicOn = UserDefaults.standard.object(forKey: "musicEnabled") as? Bool ?? true
        soundsOn = UserDefaults.standard.object(forKey: "soundsEnabled") as? Bool ?? true
        vibroOn = UserDefaults.standard.object(forKey: "vibrationEnabled") as? Bool ?? true
    }
}
