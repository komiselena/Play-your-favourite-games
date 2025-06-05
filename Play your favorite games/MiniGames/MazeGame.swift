import Foundation
import UIKit
import SpriteKit
import SwiftUI

class MazeGameScene: SKScene, ObservableObject {
    @Published var isWon = false
    
    private var mazeBackground: SKShapeNode!
    private var wallsNode: SKSpriteNode!
    private var playerNode: SKShapeNode!
    private var flagNode: SKSpriteNode!
    private var trailNodes = [SKShapeNode]()
    private var mazeCGImage: CGImage?
    private let playerRadius: CGFloat = 1.5 // Увеличил радиус для лучшей видимости
    let moveStep: CGFloat = 3
    private let startPoint = CGPoint(x: 9, y: 187)
    private let exitPoint = CGPoint(x: 186, y: 10)
    var onGameWon: (() -> Void)?
    
    // Настройки следа
    private var trailPathNode: SKShapeNode?
    private var trailPoints = [CGPoint]()
    private let trailColor = SKColor.red
    private let trailWidth: CGFloat = 1.5
    private let trailDashPattern: [CGFloat] = [3, 3] // Длина штриха и пробела
    
    override func didMove(to view: SKView) {
        mazeBackground = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 196, height: 196))
        mazeBackground.fillColor = SKColor(hex: "#746931")
        mazeBackground.strokeColor = .clear
        mazeBackground.lineWidth = 2
        mazeBackground.position = CGPoint(x: 0, y: 0)
        addChild(mazeBackground)
        
        // Векторные стены
        wallsNode = SKSpriteNode(imageNamed: "maze")
        wallsNode.anchorPoint = CGPoint(x: 0, y: 0)
        wallsNode.position = CGPoint(x: 0, y: 0)
        wallsNode.size = CGSize(width: 196, height: 196)
        addChild(wallsNode)
        
        // Флаг в правом нижнем углу
        flagNode = SKSpriteNode(imageNamed: "coin")
        flagNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        flagNode.position = exitPoint
        flagNode.zPosition = 1
        flagNode.size = CGSize(width: 20, height: 20)
        addChild(flagNode)
        
        // Получаем CGImage для проверки стен
        if let img = UIImage(named: "maze")?.cgImage {
            mazeCGImage = img
        }
        
        // Создаем игрока - красный круг
        playerNode = SKShapeNode(circleOfRadius: playerRadius)
        playerNode.fillColor = .red
        playerNode.strokeColor = .clear
        playerNode.position = startPoint
        playerNode.zPosition = 2
        addChild(playerNode)
        
        // Инициализируем узел для пути
        trailPathNode = SKShapeNode()
        trailPathNode?.strokeColor = trailColor
        trailPathNode?.lineWidth = trailWidth
        trailPathNode?.lineCap = .round
        trailPathNode?.lineJoin = .round
        trailPathNode?.zPosition = 1
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
        
        // Проверка выхода за пределы лабиринта
        guard mazeBackground.frame.contains(newPos) else { return }
        
        // Проверка столкновения со стенами
        if isWall(at: newPos) { return }
        
        // Проверка по точкам вокруг игрока
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
        
        // Обновляем позицию игрока
        playerNode.position = newPos
        
        // Добавляем след
        addTrailPoint(at: newPos)
        
        // Проверка достижения флага
        if playerNode.position.distance(to: flagNode.position) < 15 {
            isWon = true
            onGameWon?()
        }
    }
    
    private func addTrailPoint(at position: CGPoint) {
        // Добавляем точку только если она на достаточном расстоянии от предыдущей
        if let lastPoint = trailPoints.last, position.distance(to: lastPoint) < 2 {
            return
        }
        
        trailPoints.append(position)
        
        // Ограничиваем количество точек, чтобы не перегружать память
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
        
        // Создаем пунктирный путь
        let dashedPath = path.copy(dashingWithPhase: 0, lengths: trailDashPattern)
        trailPathNode?.path = dashedPath
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
        
        // Цвет фона #746931 в RGB: (116, 105, 49)
        let isBackground = (r >= 0.454 && r <= 0.456) &&  // 116/255 ≈ 0.4549
        (g >= 0.411 && g <= 0.413) &&  // 105/255 ≈ 0.4117
        (b >= 0.192 && b <= 0.194)     // 49/255 ≈ 0.1921
        
        // Белый цвет стен (R=1.0, G=1.0, B=1.0)
        let isWhiteWall = (r == 1.0 && g == 1.0 && b == 1.0)
        
        // Красный цвет игрока (R=1.0, G=0.0, B=0.0)
        let isPlayer = (r == 1.0 && g == 0.0 && b == 0.0)
        
        let othherColor = (r == 0.0 && g == 0.0 && b >= 0.31 && b <= 3.38)
        
        // Черный цвет (R=0.0, G=0.0, B=0.0)
        let isBlack = (r == 0.0 && g == 0.0 && b == 0.0)
        print("Color at \(point): R: \(String(format: "%.3f", r)), G: \(String(format: "%.3f", g)), B: \(String(format: "%.3f", b)) - \(isBackground ? "Background" : isWhiteWall ? "White Wall" : isBlack ? "Black" : "Other")")
        // Возвращаем true для всего, что НЕ является фоном и НЕ является игроком
        // ИЛИ является белой стеной, черным цветом и т.д.
        return !isBackground && !isBlack && !othherColor
    }
    
}

// Расширение для вычисления расстояния между точками
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
