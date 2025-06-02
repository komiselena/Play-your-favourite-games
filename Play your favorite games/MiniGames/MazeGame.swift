//
//  MazeGame.swift
//  Lucky Eagle Game
//
//  Created by Mac on 26.04.2025.
//

//
//  MazeGame.swift
//  Lucky Eagle Game
//
//  Created by Mac on 26.04.2025.
//

import Foundation
import UIKit
import SpriteKit
import SwiftUI

class MazeGameScene: SKScene, ObservableObject {
    @Published var isWon = false
    
    private var mazeBackground: SKShapeNode!
    private var wallsNode: SKSpriteNode!
    private var playerNode: SKSpriteNode!
    private var flagNode: SKSpriteNode!
    private var trailNodes = [SKShapeNode]()
    private var mazeCGImage: CGImage?
    private let playerRadius: CGFloat = 4
    let moveStep: CGFloat = 3
    private let startPoint = CGPoint(x: 20, y: 73)
    private let exitPoint = CGPoint(x: 186, y: 142)
    var onGameWon: (() -> Void)?
    
    // Настройки следа
    private var trailPathNode: SKShapeNode?
    private var trailPoints = [CGPoint]()
    private let trailColor = SKColor(hex: "8FC7F9") // Новый цвет следа
    private let trailWidth: CGFloat = 12.0 // Увеличим ширину следа
    private let minTrailDistance: CGFloat = 1.5 // Минимальное расстояние между точками следа
    private let blueSquarePoint = CGPoint(x: 10, y: 72) // Новая позиция для голубого квадратика

    private var blueSquareNode: SKShapeNode? // Нода для голубого квадратика

    override func didMove(to view: SKView) {
        mazeBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 196, height: 196))
        mazeBackground.fillColor = SKColor(hex: "4B2A28")
        mazeBackground.strokeColor = .red
        mazeBackground.lineWidth = 2
        mazeBackground.position = CGPoint(x: 0, y: 0)
        addChild(mazeBackground)
        
        wallsNode = SKSpriteNode(imageNamed: "maze")
        wallsNode.anchorPoint = CGPoint(x: 0, y: 0)
        wallsNode.position = CGPoint(x: 0, y: 0)
        wallsNode.size = CGSize(width: 196, height: 196)
        addChild(wallsNode)
        
        flagNode = SKSpriteNode(imageNamed: "coin")
        flagNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        flagNode.position = exitPoint
        flagNode.zPosition = 1
        flagNode.size = CGSize(width: 20, height: 20)
        addChild(flagNode)
        
        if let img = UIImage(named: "maze")?.cgImage {
            mazeCGImage = img
        }
        
        playerNode = SKSpriteNode(imageNamed: "skin1")
        playerNode.position = startPoint
        playerNode.zPosition = 2
        playerNode.size = CGSize(width: playerRadius * 3, height: playerRadius * 3)
        addChild(playerNode)

        blueSquareNode = SKShapeNode(rectOf: CGSize(width: 10, height: 10))
        blueSquareNode?.position = blueSquarePoint
        blueSquareNode?.fillColor = SKColor(hex: "8FC7F9") // Голубой цвет
        blueSquareNode?.strokeColor = .clear
        blueSquareNode?.zPosition = 1
        addChild(blueSquareNode!)

        
        let squareOutline = SKShapeNode(rectOf: CGSize(width: playerRadius*3, height: playerRadius*3))
        squareOutline.strokeColor = .clear
        squareOutline.lineWidth = 1
        squareOutline.fillColor = .clear
        squareOutline.zPosition = -1
        playerNode.addChild(squareOutline)
        
        // Инициализируем узел для пути (теперь без пунктира)
        trailPathNode = SKShapeNode()
        trailPathNode?.strokeColor = trailColor
        trailPathNode?.lineWidth = trailWidth
        trailPathNode?.lineCap = .round
        trailPathNode?.lineJoin = .round
        trailPathNode?.zPosition = 0
        addChild(trailPathNode!)
    }

    func resetGame() {
        playerNode.position = startPoint
        isWon = false
        trailPoints.removeAll()
        updateTrailPath()
    }
    
    func movePlayer(dx: CGFloat, dy: CGFloat) {
        let newPos = CGPoint(x: playerNode.position.x + dx, y: playerNode.position.y + dy)
        
        guard mazeBackground.frame.contains(newPos) else { return }
        
        if isWall(at: newPos) { return }
        
        let offsets: [CGPoint] = [
            CGPoint(x: playerRadius, y: 0), CGPoint(x: -playerRadius, y: 0),
            CGPoint(x: 0, y: playerRadius), CGPoint(x: 0, y: -playerRadius),
            CGPoint(x: playerRadius * 0.7, y: playerRadius * 0.7),
            CGPoint(x: -playerRadius * 0.7, y: playerRadius * 0.7),
            CGPoint(x: playerRadius * 0.7, y: -playerRadius * 0.7),
            CGPoint(x: -playerRadius * 0.7, y: -playerRadius * 0.7)
        ]
        
        for offset in offsets {
            if isWall(at: CGPoint(x: newPos.x + offset.x, y: newPos.y + offset.y)) {
                return
            }
        }
        
        playerNode.position = newPos
        addTrailPoint(at: newPos)
        
        if playerNode.position.distance(to: flagNode.position) < 15 {
            isWon = true
            onGameWon?()
        }
    }
    
    private func addTrailPoint(at position: CGPoint) {
        // Добавляем точку только если она на достаточном расстоянии от предыдущей
        if let lastPoint = trailPoints.last, position.distance(to: lastPoint) < minTrailDistance {
            return
        }
        
        trailPoints.append(position)
        
        // Ограничиваем количество точек
        if trailPoints.count > 500 {
            trailPoints.removeFirst(100)
        }
        
        updateTrailPath()
    }
    
    private func updateTrailPath() {
        guard !trailPoints.isEmpty else {
            trailPathNode?.path = nil
            return
        }
        
        let path = CGMutablePath()
        path.move(to: trailPoints[0])
        
        for point in trailPoints.dropFirst() {
            path.addLine(to: point)
        }
        
        // Теперь используем сплошную линию вместо пунктирной
        trailPathNode?.path = path
    }

    private func isWall(at point: CGPoint) -> Bool {
        guard let mazeCGImage = mazeCGImage else { return false }
        
        let scaleX = CGFloat(mazeCGImage.width) / wallsNode.size.width
        let scaleY = CGFloat(mazeCGImage.height) / wallsNode.size.height
        
        let imgX = Int(point.x * scaleX)
        let imgY = Int((wallsNode.size.height - point.y) * scaleY)
        
        guard imgX >= 0, imgX < mazeCGImage.width, imgY >= 0, imgY < mazeCGImage.height else {
            return true
        }
        
        guard let dataProvider = mazeCGImage.dataProvider,
              let pixelData = dataProvider.data,
              let data = CFDataGetBytePtr(pixelData) else {
            return true
        }
        
        let bytesPerPixel = mazeCGImage.bitsPerPixel / 8
        let bytesPerRow = mazeCGImage.bytesPerRow
        let pixelIndex = bytesPerRow * imgY + imgX * bytesPerPixel
        
        let totalBytes = CFDataGetLength(pixelData)
        guard pixelIndex >= 0, pixelIndex + 2 < totalBytes else {
            return true
        }
        
        let r = CGFloat(data[pixelIndex]) / 255.0
        let g = CGFloat(data[pixelIndex + 1]) / 255.0
        let b = CGFloat(data[pixelIndex + 2]) / 255.0
        
        // Цвет фона #DFA6F2 в RGB: (223, 166, 242)
        let isBackground = (r >= 0.87 && r <= 0.88) &&
                           (g >= 0.65 && g <= 0.66) &&
                           (b >= 0.94 && b <= 0.96)
        let playerColor = (r == 0.0 && g == 0.0 && b == 0.0)
        
        let isBrownWall = (r >= 0.62 && r <= 0.64) &&
                          (g >= 0.44 && g <= 0.46) &&
                          (b >= 0.20 && b <= 0.22)
        
        let isBluePath = (r >= 0.55 && r <= 0.57) &&
                        (g >= 0.78 && g <= 0.80) &&
                        (b >= 0.97 && b <= 0.98)
        
        let isBrownColor1 = (r >= 0.62 && r <= 0.64) && (g >= 0.44 && g <= 0.46) && (b >= 0.20 && b <= 0.22)
        let isBrownColor2 = (r >= 0.72 && r <= 0.74) && (g >= 0.47 && g <= 0.49) && (b >= 0.10 && b <= 0.12)
        let isBrownColor3 = (r >= 0.52 && r <= 0.54) && (g >= 0.45 && g <= 0.48) && (b >= 0.24 && b <= 0.26)
        let isBrownColor4 = (r >= 0.79 && r <= 0.81) && (g >= 0.54 && g <= 0.56) && (b >= 0.14 && b <= 0.16)
        
        let isLightBlueColor1 = (r >= 0.48 && r <= 0.50) && (g >= 0.78 && g <= 0.80) && (b >= 0.99 && b <= 1.01)
        let isLightBlueColor2 = (r >= 0.49 && r <= 0.51) && (g >= 0.77 && g <= 0.79) && (b >= 0.94 && b <= 0.96)
        let isLightBlueColor3 = (r >= 0.48 && r <= 0.50) && (g >= 0.79 && g <= 0.81) && (b >= 0.99 && b <= 1.01)

        return !isBackground && !playerColor && !isBluePath && !isBrownWall && !isLightBlueColor1 && !isBrownColor1 && !isLightBlueColor2 && !isBrownColor2 && !isLightBlueColor3 && !isBrownColor3 && !isBrownColor4
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(x - point.x, y - point.y)
    }
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexValue.hasPrefix("#") {
            hexValue.remove(at: hexValue.startIndex)
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)
        
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}
