

/*
 
//
//  GameScene.swift
//  TerritoryGame
//
//  Created by Developer on 29.05.2024.
//

import SpriteKit
import SwiftUI

enum TerritoryOwner {
    case player
    case enemy
    case neutral
}

struct TerritoryData {
    let id: String
    let borderWidth: CGFloat
    var owner: TerritoryOwner
    var soldiers: Int
}

class TerritoryNode: SKSpriteNode {
    var territoryId: String = ""
    var owner: TerritoryOwner = .neutral {
        didSet {
            updateAppearance()
            updateTerritoryColor()
        }
    }
    var soldiers: Int = 0 {
        didSet { updateSoldiersCount() }
    }
    
    private var circleNode: SKShapeNode!
    private var iconNode: SKSpriteNode!
    private var labelNode: SKLabelNode!
    
    init(texture: SKTexture?, size: CGSize) {
        super.init(texture: texture, color: .clear, size: size)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        // Setup circle background (smaller size)
        circleNode = SKShapeNode(circleOfRadius: 15)
        circleNode.position = CGPoint(x: 0, y: 0)
        circleNode.zPosition = 10
        self.addChild(circleNode)
        
        // Setup icon (smaller size)
        iconNode = SKSpriteNode()
        iconNode.size = CGSize(width: 20, height: 20)
        iconNode.position = circleNode.position
        iconNode.zPosition = 11
        self.addChild(iconNode)
        
        // Setup label
        labelNode = SKLabelNode()
        labelNode.fontName = "Avenir-Black"
        labelNode.fontSize = 14
        labelNode.zPosition = 12
        labelNode.position = CGPoint(x: circleNode.position.x, y: circleNode.position.y - 25)
        self.addChild(labelNode)
        
        updateAppearance()
        updateTerritoryColor()
    }
    
    func updateAppearance() {
        switch owner {
        case .player:
            circleNode.fillColor = SKColor(red: 0.91, green: 0.73, blue: 0.28, alpha: 1.0)
            circleNode.strokeColor = .clear
            iconNode.texture = SKTexture(imageNamed: "skin1")
            labelNode.fontColor = SKColor(red: 0.91, green: 0.73, blue: 0.28, alpha: 1.0)
        case .enemy:
            circleNode.fillColor = .red
            circleNode.strokeColor = .clear
            iconNode.texture = SKTexture(imageNamed: "skin2")
            labelNode.fontColor = .white
        case .neutral:
            circleNode.fillColor = .gray
            circleNode.strokeColor = .clear
            iconNode.texture = SKTexture(image: UIImage(systemName: "questionmark")!)
            labelNode.fontColor = .white
        }
        
        updateSoldiersCount()
    }
    
    func updateTerritoryColor() {
        switch owner {
        case .player:
            self.color = SKColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 0.8)
            self.colorBlendFactor = 1.0
        case .enemy:
            self.color = SKColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.8)
            self.colorBlendFactor = 1.0
        case .neutral:
            self.color = SKColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
            self.colorBlendFactor = 1.0
        }
    }

    func updateSoldiersCount() {
        labelNode.text = "\(soldiers)"
    }
}

class GameScene: SKScene {
        
    private var territories: [TerritoryNode] = []
    private var selectedFromTerritory: TerritoryNode?
    private var selectedToTerritory: TerritoryNode?
    private var lastUpdateTime: TimeInterval = 0
    private var mapOffset: CGPoint = .zero
    
    private var enemyAIUpdateInterval: TimeInterval = 5.0
    private var lastEnemyAIUpdateTime: TimeInterval = 0
    private var isEnemyAIActive: Bool = false
    
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "bg1")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = self.size
        background.zPosition = -1
        addChild(background)
        
        processMapAndGenerateZones()
    }
    
    func processMapAndGenerateZones() {
        guard let image = UIImage(named: "map")?.cgImage else {
            print("❌ Картинка map не найдена")
            return
        }

        let width = image.width
        let height = image.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let totalBytes = height * bytesPerRow

        var pixelData = [UInt8](repeating: 0, count: totalBytes)
        guard let context = CGContext(data: &pixelData,
                                    width: width,
                                    height: height,
                                    bitsPerComponent: 8,
                                    bytesPerRow: bytesPerRow,
                                    space: CGColorSpaceCreateDeviceRGB(),
                                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            print("❌ Не удалось создать CGContext")
            return
        }

        context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))

        var visited = Set<Int>()
        var territoryNodes = [TerritoryNode]()

        // Рассчитываем смещение для центрирования
        let offsetX = (size.width - CGFloat(width)) / 2
        let offsetY = (size.height - CGFloat(height)) / 2

        for y in 0..<height {
            for x in 0..<width {
                let index = (y * width + x) * bytesPerPixel
                if visited.contains(index) || isBorderPixel(at: index, in: pixelData) {
                    continue
                }

                var zoneMask = [UInt8](repeating: 0, count: totalBytes)
                let territoryColor = extractTerritoryColor(x: x, y: y, width: width, height: height,
                                                         originalData: &pixelData,
                                                         visited: &visited,
                                                         zoneMask: &zoneMask,
                                                         bytesPerPixel: bytesPerPixel)

                if let zoneImage = maskToCGImage(mask: zoneMask, width: width, height: height) {
                    let texture = SKTexture(cgImage: zoneImage)
                    let territory = createTerritoryNode(from: texture,
                                                      color: territoryColor,
                                                      offset: CGPoint(x: offsetX, y: offsetY))
                    territoryNodes.append(territory)
                }
            }
        }

        for territory in territoryNodes {
            addChild(territory)
        }
    }


    func isBorderPixel(at index: Int, in data: [UInt8]) -> Bool {
        // Белый цвет считается границей
        return data[index] > 200 && data[index+1] > 200 && data[index+2] > 200
    }

    func extractTerritoryColor(x: Int, y: Int,
                             width: Int, height: Int,
                             originalData: inout [UInt8],
                             visited: inout Set<Int>,
                             zoneMask: inout [UInt8],
                             bytesPerPixel: Int) -> UIColor {
        var stack = [(x, y)]
        var territoryColor: UIColor = .clear
        var isFirstPixel = true

        while let (cx, cy) = stack.popLast() {
            let index = (cy * width + cx) * bytesPerPixel
            
            if cx < 0 || cy < 0 || cx >= width || cy >= height { continue }
            if visited.contains(index) || isBorderPixel(at: index, in: originalData) { continue }

            visited.insert(index)

            // Запоминаем цвет первого пикселя территории
            if isFirstPixel {
                let r = originalData[index]
                let g = originalData[index + 1]
                let b = originalData[index + 2]
                territoryColor = UIColor(red: CGFloat(r)/255.0,
                                       green: CGFloat(g)/255.0,
                                       blue: CGFloat(b)/255.0,
                                       alpha: 0.5) // Полупрозрачный
                isFirstPixel = false
            }

            // В маске делаем пиксель белым (граница) или прозрачным (внутренность)
            if isOnBorder(x: cx, y: cy, width: width, height: height, data: originalData, bytesPerPixel: bytesPerPixel) {
                zoneMask[index] = 255     // R
                zoneMask[index + 1] = 255 // G
                zoneMask[index + 2] = 255 // B
                zoneMask[index + 3] = 255 // A (непрозрачный)
            } else {
                zoneMask[index] = 255     // R
                zoneMask[index + 1] = 255 // G
                zoneMask[index + 2] = 255 // B
                zoneMask[index + 3] = 0   // A (прозрачный)
            }

            stack.append((cx + 1, cy))
            stack.append((cx - 1, cy))
            stack.append((cx, cy + 1))
            stack.append((cx, cy - 1))
        }

        return territoryColor
    }

    func isOnBorder(x: Int, y: Int, width: Int, height: Int, data: [UInt8], bytesPerPixel: Int) -> Bool {
        // Проверяем соседние пиксели на наличие границы
        let directions = [(1, 0), (-1, 0), (0, 1), (0, -1)]
        
        for (dx, dy) in directions {
            let nx = x + dx
            let ny = y + dy
            
            if nx < 0 || ny < 0 || nx >= width || ny >= height {
                return true
            }
            
            let neighborIndex = (ny * width + nx) * bytesPerPixel
            if isBorderPixel(at: neighborIndex, in: data) {
                return true
            }
        }
        
        return false
    }


    func createTerritoryNode(from texture: SKTexture, color: UIColor, offset: CGPoint) -> TerritoryNode {
        let node = TerritoryNode(texture: texture, size: texture.size())
        node.color = color
        node.colorBlendFactor = 1.0
        node.position = CGPoint(x: offset.x + node.size.width/2,
                               y: offset.y + node.size.height/2)
        
        
        return node
    }

        func maskToCGImage(mask: [UInt8], width: Int, height: Int) -> CGImage? {
            let bytesPerPixel = 4
            let bytesPerRow = bytesPerPixel * width

            guard let ctx = CGContext(data: UnsafeMutableRawPointer(mutating: mask),
                                      width: width,
                                      height: height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: CGColorSpaceCreateDeviceRGB(),
                                      bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
                return nil
            }

            return ctx.makeImage()
        }

    func addZoneSprite(from texture: SKTexture, fillColor: UIColor) {
        let zone = SKSpriteNode(texture: texture)
        zone.position = CGPoint(x: size.width / 2, y: size.height / 2)
        zone.alpha = 1.0
        zone.color = .clear
        zone.colorBlendFactor = 1.0
        addChild(zone)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        if selectedFromTerritory == nil {
            for territory in territories {
                if territory.contains(location) && territory.owner == .player {
                    selectedFromTerritory = territory
                    territory.run(SKAction.sequence([
                        SKAction.scale(to: 1.1, duration: 0.1),
                        SKAction.repeatForever(
                            SKAction.sequence([
                                SKAction.fadeAlpha(to: 0.8, duration: 0.5),
                                SKAction.fadeAlpha(to: 1.0, duration: 0.5)
                            ])
                        )
                    ]))
                    return
                }
            }
        } else {
            for territory in territories {
                if territory.contains(location) && territory != selectedFromTerritory {
                    selectedToTerritory = territory
                    selectedFromTerritory?.removeAllActions()
                    selectedFromTerritory?.run(SKAction.scale(to: 1.0, duration: 0.1))
                    launchAttack(from: selectedFromTerritory!, to: selectedToTerritory!)
                    selectedFromTerritory = nil
                    selectedToTerritory = nil
                    return
                }
            }
            
            selectedFromTerritory?.removeAllActions()
            selectedFromTerritory?.run(SKAction.scale(to: 1.0, duration: 0.1))
            selectedFromTerritory = nil
        }
    }
    
    private func launchAttack(from: TerritoryNode, to: TerritoryNode) {
        guard from.soldiers > 0 else { return }
        
        let soldiersToSend = from.soldiers
        from.soldiers = 0
        from.updateSoldiersCount()
        
        animateSoldiersMovement(from: from, to: to, count: soldiersToSend) {
            self.resolveAttack(from: from, to: to, soldiers: soldiersToSend)
            self.isEnemyAIActive = false
        }
    }
    
    private func animateSoldiersMovement(from: TerritoryNode, to: TerritoryNode, count: Int, completion: @escaping () -> Void) {
        let group = DispatchGroup()
        let soldiersCount = min(count, 100)
        
        let color: UIColor = from.owner == .player ?
            UIColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0) : .red
        
        let rows = 3
        let cols = 3
        let spacing: CGFloat = 8
        
        for i in 0..<soldiersCount {
            group.enter()
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.1) {
                let row = i % rows
                let col = (i / rows) % cols
                
                let soldier = SKShapeNode(circleOfRadius: 3)
                soldier.fillColor = color
                soldier.strokeColor = .clear
                
                let xOffset = CGFloat(col - cols/2) * spacing
                let yOffset = CGFloat(row - rows/2) * spacing
                soldier.position = CGPoint(
                    x: from.position.x + xOffset,
                    y: from.position.y + yOffset
                )
                
                soldier.zPosition = 5
                self.addChild(soldier)
                
                let moveAction = SKAction.move(to: CGPoint(
                    x: to.position.x + xOffset,
                    y: to.position.y + yOffset
                ), duration: 4.0)
                
                let fadeAction = SKAction.fadeOut(withDuration: 0.2)
                let removeAction = SKAction.removeFromParent()
                let sequence = SKAction.sequence([moveAction, fadeAction, removeAction])
                
                soldier.run(sequence) {
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func resolveAttack(from: TerritoryNode, to: TerritoryNode, soldiers: Int) {
        if to.owner == from.owner {
            to.soldiers += soldiers
        } else {
            if soldiers > to.soldiers {
                to.owner = from.owner
                to.soldiers = soldiers - to.soldiers
                to.updateAppearance()
            } else {
                to.soldiers -= soldiers
            }
        }
        
        to.updateSoldiersCount()
        checkGameEnd()
    }
    
    private func checkGameEnd() {
        var playerCount = 0
        var enemyCount = 0
        
        for territory in territories {
            if territory.owner == .player {
                playerCount += 1
            } else if territory.owner == .enemy {
                enemyCount += 1
            }
        }
        
        if playerCount == 0 {
            showGameOver(winner: .enemy)
        } else if enemyCount == 0 {
            showGameOver(winner: .player)
        }
    }
    
    private func showGameOver(winner: TerritoryOwner) {
        let gameOverNode = SKSpriteNode(color: .black.withAlphaComponent(0.7), size: size)
        gameOverNode.position = CGPoint(x: size.width/2, y: size.height/2)
        gameOverNode.zPosition = 100
        addChild(gameOverNode)
        
        let message = SKLabelNode(text: winner == .player ? "VICTORY!" : "DEFEAT!")
        message.fontName = "Avenir-Black"
        message.fontSize = 60
        message.fontColor = winner == .player ?
            SKColor(red: 0.0, green: 0.5, blue: 1.0, alpha: 1.0) : .red
        message.position = CGPoint(x: 0, y: 20)
        message.zPosition = 101
        gameOverNode.addChild(message)
        
        let restartButton = SKLabelNode(text: "Tap to Restart")
        restartButton.fontName = "Avenir-Medium"
        restartButton.fontSize = 30
        restartButton.fontColor = .white
        restartButton.position = CGPoint(x: 0, y: -50)
        restartButton.zPosition = 101
        restartButton.name = "restart"
        gameOverNode.addChild(restartButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        if let node = self.nodes(at: location).first as? SKLabelNode, node.name == "restart" {
            view?.presentScene(GameScene(size: size))
        }
    }
}


*/
