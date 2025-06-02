//
//  GameViewModel.swift
//  Potawatomi tribe game
//
//  Created by Mac on 13.05.2025.
//

import Foundation


class GameViewModel: ObservableObject {
    @Published var backgroundImage: String = "bg1"
    @Published var map: String = "map1"
    @Published var skin: String = "skin1"
    
    @Published var currentLevel: Int = 1
    @Published var unlockedLevels: Int = 1
    
    func completeLevel(_ level: Int) {
        if level == unlockedLevels {
            unlockedLevels = min(unlockedLevels + 1, 6)
        }
        currentLevel = level
    }
    
    func nextLevel() {
        let next = currentLevel + 1
        if next <= unlockedLevels {
            currentLevel = next
            map = "map\(next)"
        }
    }

    @Published var isGameOver: Bool = false
    @Published var restartGame: Bool = false
    
    @Published var played10Times: Bool = false
    @Published var collected100Coins: Bool = false
    @Published var unlockedAllBattleFields: Bool = false
    @Published var accumulated1000Coins: Bool = false
    @Published var unlockedAllKings: Bool = false

    
    @Published var hidePlayed10Times = false
    @Published var hideCcollected100Coins = false
    @Published var hideUnlockedAllBattleFields = false
    @Published var hideUnlockedAllKings = false
    @Published var hideAccumulated = false

}
