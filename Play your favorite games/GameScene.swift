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
    var soldiers: Int {
        didSet {
            if owner == .player && soldiers <= (oldValue - 1) {
                soldiers = oldValue
            }
        }
    }
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
        didSet {
            updateSoldiersCount()
            updateTerritoryColor() // Обновляем цвет при изменении количества солдат
        }
    }
    private var borderNode: SKShapeNode! // Новая нода для границы

    private var circleNode: SKShapeNode!
    private var iconNode: SKSpriteNode!
    private var labelNode: SKLabelNode!
    fileprivate var backgroundNode: SKSpriteNode!
    private var cropNode: SKCropNode!
    
    fileprivate var isSelected = false {
        didSet {
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let scene = self.scene as? GameScene else { return }
        scene.territoryTapped(self)
    }
    
    init(texture: SKTexture?, size: CGSize) {
        super.init(texture: texture, color: .clear, size: size)
        self.isUserInteractionEnabled = true  // Включаем обработку касаний
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        cropNode = SKCropNode()
        let maskNode = SKSpriteNode(texture: self.texture)
        maskNode.position = CGPoint(x: 0, y: 0)
        cropNode.maskNode = maskNode
        
        backgroundNode = SKSpriteNode(color: .clear, size: self.size)
        backgroundNode.position = CGPoint(x: 0, y: 0)
        backgroundNode.zPosition = -1
        cropNode.addChild(backgroundNode)
        
        self.addChild(cropNode)
        
        circleNode = SKShapeNode(circleOfRadius: 15)
        circleNode.position = CGPoint(x: 0, y: 0)
        circleNode.zPosition = 10
        self.addChild(circleNode)
        
        iconNode = SKSpriteNode()
        iconNode.size = CGSize(width: 20, height: 20)
        iconNode.position = circleNode.position
        iconNode.zPosition = 11
        self.addChild(iconNode)
        
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
            circleNode.fillColor = UIColor(hex: "#4355F5")
            circleNode.strokeColor = .clear
            iconNode.texture = SKTexture(imageNamed: "skin1")
            labelNode.fontColor = .white
            if soldiers <= 10 { soldiers = 11 }
        case .enemy:
            circleNode.fillColor = UIColor(hex: "#C8423F")
            circleNode.strokeColor = .clear
            iconNode.texture = SKTexture(imageNamed: "skin2")
            labelNode.fontColor = .white
            if soldiers >= 11 { soldiers = 10 }
        case .neutral:
            circleNode.fillColor = .lightGray // Более светлый серый
            circleNode.strokeColor = .clear
            iconNode.texture = SKTexture(image: UIImage(systemName: "questionmark")!)
            labelNode.fontColor = .white
        }
        
        updateSoldiersCount()
    }
    
    private func createBorder() {
        guard let texture = self.texture else { return }
        let cgImage = texture.cgImage()
        
        let width = cgImage.width
        let height = cgImage.height
        
        // Создаем контекст для обработки изображения
        guard let context = CGContext(data: nil,
                                    width: width,
                                    height: height,
                                    bitsPerComponent: 8,
                                    bytesPerRow: 4 * width,
                                    space: CGColorSpaceCreateDeviceRGB(),
                                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return }
        
        // Рисуем изображение в контексте
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Получаем данные изображения
        guard let data = context.data else { return }
        let buffer = data.bindMemory(to: UInt8.self, capacity: width * height * 4)
        
        // Создаем путь для границы
        let borderPath = CGMutablePath()
        let step = 2 // Уменьшаем шаг для более точного определения границы
        
        // Ищем граничные пиксели
        for y in stride(from: 0, to: height, by: step) {
            for x in stride(from: 0, to: width, by: step) {
                let offset = (y * width + x) * 4
                let alpha = buffer[offset + 3]
                
                if alpha > 0 { // Если пиксель принадлежит территории
                    // Проверяем соседние пиксели (4-связность)
                    var isBorder = false
                    let neighbors = [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]
                    
                    for (nx, ny) in neighbors {
                        if nx >= 0 && nx < width && ny >= 0 && ny < height {
                            let neighborOffset = (ny * width + nx) * 4
                            if buffer[neighborOffset + 3] == 0 {
                                isBorder = true
                                break
                            }
                        } else {
                            isBorder = true // Край изображения
                        }
                    }
                    
                    if isBorder {
                        // Добавляем точку в путь (учитываем смещение)
                        let point = CGPoint(x: x - width/2, y: y - height/2)
                        if borderPath.isEmpty {
                            borderPath.move(to: point)
                        } else {
                            borderPath.addLine(to: point)
                        }
                    }
                }
            }
        }
        
        // Создаем ноду для границы
        borderNode = SKShapeNode(path: borderPath)
        borderNode.strokeColor = .white
        borderNode.lineWidth = 2.0
        borderNode.lineCap = .round
        borderNode.lineJoin = .round
        borderNode.fillColor = .clear
        borderNode.zPosition = 1
        
        // Учитываем размер текстуры
        let textureSize = texture.size()
        let scaleX = self.size.width / textureSize.width
        let scaleY = self.size.height / textureSize.height
        
        // Позиционируем границу в центре ноды
        borderNode.position = CGPoint(x: 0, y: 0)
        borderNode.xScale = scaleX
        borderNode.yScale = scaleY
        
        self.addChild(borderNode)
    }

    private func findContourPath(cgImage: CGImage) -> CGPath? {
        let width = cgImage.width
        let height = cgImage.height
        
        // Создаем контекст для обработки изображения
        guard let context = CGContext(data: nil,
                                    width: width,
                                    height: height,
                                    bitsPerComponent: 8,
                                    bytesPerRow: 4 * width,
                                    space: CGColorSpaceCreateDeviceRGB(),
                                    bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else { return nil }
        
        // Рисуем изображение в контексте
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        // Получаем данные изображения
        guard let data = context.data else { return nil }
        let buffer = data.bindMemory(to: UInt8.self, capacity: width * height * 4)
        
        // Создаем путь для контура
        let path = CGMutablePath()
        let step = 5 // Шаг для проверки пикселей
        
        // Ищем граничные пиксели
        for y in stride(from: 0, to: height, by: step) {
            for x in stride(from: 0, to: width, by: step) {
                let offset = (y * width + x) * 4
                let alpha = buffer[offset + 3]
                
                if alpha > 0 {
                    // Проверяем соседние пиксели
                    var isBorder = false
                    
                    // Проверяем 4 соседних пикселя
                    let neighbors = [(x-1, y), (x+1, y), (x, y-1), (x, y+1)]
                    for (nx, ny) in neighbors {
                        if nx >= 0 && nx < width && ny >= 0 && ny < height {
                            let neighborOffset = (ny * width + nx) * 4
                            if buffer[neighborOffset + 3] == 0 {
                                isBorder = true
                                break
                            }
                        } else {
                            isBorder = true
                        }
                    }
                    
                    if isBorder {
                        // Добавляем точку в путь (убедимся, что координаты в пределах UInt8)
                        let rect = CGRect(x: min(max(x, 0), width-1),
                                      y: min(max(y, 0), height-1),
                                      width: 1, height: 1)
                        path.addRect(rect)
                    }
                }
            }
        }
        
        return path
    }
    
    func updateTerritoryColor() {
        let overlayColor: UIColor
        switch owner {
        case .player:
            // Динамический цвет в зависимости от количества солдат (от светлого к темному)
            let maxSoldiers: CGFloat = 50.0 // Максимальное количество для расчета градиента
            let soldierRatio = min(CGFloat(soldiers) / maxSoldiers, 1.0)
            
            // Базовый цвет #4355F5 с изменяющейся насыщенностью
            let baseHue: CGFloat = 0.64 // Примерное значение Hue для #4355F5
            let baseSaturation: CGFloat = 0.73
            let baseBrightness: CGFloat = 0.96
            
            // Уменьшаем яркость при увеличении армии
            let adjustedBrightness = baseBrightness * (1.0 - soldierRatio * 0.3)
            overlayColor = UIColor(
                hue: baseHue,
                saturation: baseSaturation,
                brightness: adjustedBrightness,
                alpha: 1.0
            )
        case .enemy:
            overlayColor = UIColor(hex: "#C8423F")
        case .neutral:
            overlayColor = UIColor.lightGray // Более светлый серый
        }
        
        if let texture = self.texture {
            if let coloredTexture = colorizeTexture(texture, color: overlayColor, intensity: 1.0) {
                backgroundNode.texture = SKTexture(image: coloredTexture)
            }
        }
    }

    func updateSoldiersCount() {
        labelNode.text = "\(soldiers)"
    }
    
    
    
    private func createWhiteBaseTexture(_ texture: SKTexture) -> UIImage? {
        let cgImage = texture.cgImage()
        
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let data = context.data else { return nil }
        let buffer = data.bindMemory(to: UInt8.self, capacity: width * height * bytesPerPixel)
        
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * bytesPerRow) + (x * bytesPerPixel)
                let alpha = CGFloat(buffer[offset + 3]) / 255.0
                
                if alpha > 0 {
                    // Заполняем белым цветом с небольшой прозрачностью
                    buffer[offset] = 255     // R
                    buffer[offset + 1] = 255  // G
                    buffer[offset + 2] = 255  // B
                    buffer[offset + 3] = 255 // A (немного прозрачный)
                }
            }
        }
        
        guard let whiteCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: whiteCGImage)
    }
    
    private func colorizeTexture(_ texture: SKTexture, color: UIColor, intensity: CGFloat) -> UIImage? {
        let cgImage = texture.cgImage()
        
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        var colorR: CGFloat = 0, colorG: CGFloat = 0, colorB: CGFloat = 0, colorA: CGFloat = 0
        color.getRed(&colorR, green: &colorG, blue: &colorB, alpha: &colorA)
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let data = context.data else { return nil }
        let buffer = data.bindMemory(to: UInt8.self, capacity: width * height * bytesPerPixel)
        
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * bytesPerRow) + (x * bytesPerPixel)
                let alpha = CGFloat(buffer[offset + 3]) / 255.0
                
                if alpha > 0 {
                    // Ограничиваем значения в диапазоне 0...255 перед преобразованием в UInt8
                    let r = max(0, min(255, colorR * 255 * intensity))
                    let g = max(0, min(255, colorG * 255 * intensity))
                    let b = max(0, min(255, colorB * 255 * intensity))
                    let a = max(0, min(255, colorA * 255 * alpha))
                    
                    buffer[offset] = UInt8(r)
                    buffer[offset + 1] = UInt8(g)
                    buffer[offset + 2] = UInt8(b)
                    buffer[offset + 3] = UInt8(a)
                }
            }
        }
        
        guard let coloredCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: coloredCGImage)
    }
}

class GameScene: SKScene {
    
    var gameViewModel: GameViewModel?
    var gameData: GameData?

    
    private var territories: [TerritoryNode] = []
    private var selectedFromTerritory: TerritoryNode?
    private var selectedToTerritory: TerritoryNode?
    private var lastUpdateTime: TimeInterval = 0
    private var mapOffset: CGPoint = .zero
    private var attackInProgress = false
    var dismissAction: (() -> Void)?

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: gameViewModel?.backgroundImage ?? "bg1")
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.size = self.size
        background.zPosition = -1
        addChild(background)
        
        processAndCreateTerritories()
        
        // Генерация солдат каждую секунду
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 1.0),
            SKAction.run(generateSoldiers)
        ])))
        
        // AI врага каждые 8 секунд (было 5)
        run(SKAction.repeatForever(SKAction.sequence([
            SKAction.wait(forDuration: 8.0),
            SKAction.run(enemyAIAttack)
        ])))
    }

    private func generateSoldiers() {
        for territory in territories where territory.owner != .neutral {
            territory.soldiers += 1
        }
    }
    
    
    private func processAndCreateTerritories() {
        let mapImageName = gameViewModel?.map ?? "map1"
        guard let originalImage = UIImage(named: mapImageName),
              let cgImage = originalImage.cgImage else {
            print("Failed to load map image")
            return
        }

        let regions = findRegions(in: cgImage)
        let targetWidth = size.width / 2.1
        let scale = targetWidth / CGFloat(cgImage.width)
        
        let mapContainer = SKNode()
        mapContainer.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(mapContainer)
        
        for (index, region) in regions.enumerated() {
            if let territoryImage = createTerritoryImage(from: region, in: cgImage) {
                let texture = SKTexture(image: territoryImage)
                let territoryNode = TerritoryNode(texture: texture, size: texture.size())
                territoryNode.setScale(scale)
                
                let center = calculateRegionCenter(region)
                let position = CGPoint(
                    x: (center.x - CGFloat(cgImage.width)/2) * scale,
                    y: (center.y - CGFloat(cgImage.height)/2) * scale
                )
                territoryNode.position = position
                territoryNode.isUserInteractionEnabled = true
                territoryNode.name = "territory_\(index)"
                territoryNode.zPosition = 0
                
                // Определяем владельца территории по цвету
                if let averageColor = calculateAverageColor(for: region, in: cgImage) {
                    if isPlayerColor(averageColor) {
                        territoryNode.owner = .player
                        territoryNode.soldiers = 11
                    } else if isEnemyColor(averageColor) {
                        territoryNode.owner = .enemy
                        territoryNode.soldiers = 10
                    } else {
                        territoryNode.owner = .neutral
                        territoryNode.soldiers = 0
                    }
                }
                
                mapContainer.addChild(territoryNode)
                territories.append(territoryNode)
            }
        }
    }

    override func update(_ currentTime: TimeInterval) {
        // Отладочная информация о территориях
        print("Territories count: \(territories.count)")
        for territory in territories {
            print("Territory \(territory.name ?? "unnamed") at \(territory.position), size: \(territory.size), frame: \(territory.frame)")
        }
    }
    
    // MARK: - Обработка касаний
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        // Отладочная информация
        print("Touch at location: \(location)")
        
        // Если атака уже идет - игнорируем все касания
        guard !attackInProgress else {
            print("Attack in progress - ignoring touches")
            return
        }
        
        // Проверяем, была ли нажата территория
        let touchedNodes = nodes(at: location)
        print("Touched nodes: \(touchedNodes.map { $0.name ?? "unnamed" })")
        
        // Ищем территорию среди всех нажатых узлов
        guard let tappedTerritory = (touchedNodes.first { $0 is TerritoryNode }) as? TerritoryNode else {
            // Тап не по территории - сбрасываем выбор
            print("No territory tapped")
            selectedFromTerritory?.isSelected = false
            selectedFromTerritory = nil
            return
        }
        
        print("Tapped territory: \(tappedTerritory.name ?? "unnamed"), owner: \(tappedTerritory.owner), soldiers: \(tappedTerritory.soldiers)")
        
        // Если еще не выбрана исходная территория
        if selectedFromTerritory == nil {
            // Можно выбрать только свою территорию
            if tappedTerritory.owner == .player {
                selectedFromTerritory = tappedTerritory
                tappedTerritory.isSelected = true
                print("Selected territory: \(selectedFromTerritory?.name ?? "none")")
            } else {
                print("Can't select enemy/neutral territory as source")
            }
        }
        // Если уже выбрана исходная территория
        else {
            // Нельзя выбирать ту же территорию
            guard tappedTerritory != selectedFromTerritory else {
                print("Same territory tapped - ignoring")
                return
            }
            
            // Проверяем возможность атаки
            if tappedTerritory.owner != .player || isAdjacent(selectedFromTerritory!, tappedTerritory) {
                selectedToTerritory = tappedTerritory
                print("Launching attack from \(selectedFromTerritory!.name ?? "") to \(selectedToTerritory!.name ?? "")")
                launchAttack(from: selectedFromTerritory!, to: selectedToTerritory!)
                selectedFromTerritory?.isSelected = false
                selectedFromTerritory = nil
                selectedToTerritory = nil
            } else {
                print("Can't attack this territory - not adjacent or invalid target")
            }
        }
    }
    
    private func colorizeTexture(_ texture: SKTexture, color: UIColor, intensity: CGFloat) -> UIImage? {
        let cgImage = texture.cgImage()
        
        let width = cgImage.width
        let height = cgImage.height
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        
        var colorR: CGFloat = 0, colorG: CGFloat = 0, colorB: CGFloat = 0, colorA: CGFloat = 0
        color.getRed(&colorR, green: &colorG, blue: &colorB, alpha: &colorA)
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return nil }
        
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        guard let data = context.data else { return nil }
        let buffer = data.bindMemory(to: UInt8.self, capacity: width * height * bytesPerPixel)
        
        for y in 0..<height {
            for x in 0..<width {
                let offset = (y * bytesPerRow) + (x * bytesPerPixel)
                let alpha = CGFloat(buffer[offset + 3]) / 255.0
                
                if alpha > 0 {
                    // Полностью заменяем цвет пикселя
                    buffer[offset] = UInt8(colorR * 255 * intensity)
                    buffer[offset + 1] = UInt8(colorG * 255 * intensity)
                    buffer[offset + 2] = UInt8(colorB * 255 * intensity)
                    // Альфа остается без изменений
                }
            }
        }
        
        guard let coloredCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: coloredCGImage)
    }


    // Проверка соседства территорий
    private func isAdjacent(_ territory1: TerritoryNode, _ territory2: TerritoryNode) -> Bool {
        let distance = hypot(territory1.position.x - territory2.position.x,
                             territory1.position.y - territory2.position.y)
        return distance < 120 // Подберите подходящее значение
    }
    
    private func launchAttack(from: TerritoryNode, to: TerritoryNode) {
        // Минимальное количество солдат для атаки
        guard from.soldiers > 1 else { return }
        
        let soldiersToSend = from.soldiers - 1
        from.soldiers = 1
        
        attackInProgress = true
        animateSoldiersMovement(from: from, to: to, count: soldiersToSend) {
            self.resolveAttack(from: from, to: to, soldiers: soldiersToSend)
            self.attackInProgress = false
            print("Attacking with \(soldiersToSend) soldiers")
        }
    }
    private func animateSoldiersMovement(from: TerritoryNode, to: TerritoryNode, count: Int, completion: @escaping () -> Void) {
        let soldiersCount = min(count, 300)
        
        let fromPosition = from.positionInScene
        let toPosition = to.positionInScene
        
        let rows = 4
        let soldiersPerRow = soldiersCount / rows
        let offset: CGFloat = 12.0
        
        let totalDuration: TimeInterval = 4.0
        
        let direction = CGVector(
            dx: toPosition.x - fromPosition.x,
            dy: toPosition.y - fromPosition.y
        )
        let distance = hypot(direction.dx, direction.dy)
        let normalizedDirection = CGVector(
            dx: direction.dx / distance,
            dy: direction.dy / distance
        )
        
        for row in 0..<rows {
            for i in 0..<(row < rows-1 ? soldiersPerRow : soldiersCount - soldiersPerRow*(rows-1)) {
                let delay = Double(row) * 0.4 + Double(i) * 0.08
                
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    // Создаем желтого солдата
                    let soldier = SKShapeNode(circleOfRadius: 1.8)
                    soldier.fillColor = UIColor(
                        red: 0.96,
                        green: 0.82,
                        blue: 0.24,
                        alpha: 1.0
                    )
                    soldier.strokeColor = .clear
                    
                    let perpendicular = CGVector(dx: -normalizedDirection.dy, dy: normalizedDirection.dx)
                    let rowOffset = CGFloat(row - rows/2) * offset
                    let soldierPosition = CGPoint(
                        x: fromPosition.x + perpendicular.dx * rowOffset,
                        y: fromPosition.y + perpendicular.dy * rowOffset
                    )
                    
                    soldier.position = soldierPosition
                    soldier.zPosition = 5
                    self.addChild(soldier)

                    let moveAction = SKAction.move(
                        to: CGPoint(
                            x: toPosition.x + perpendicular.dx * rowOffset * 0.3,
                            y: toPosition.y + perpendicular.dy * rowOffset * 0.3
                        ),
                        duration: totalDuration
                    )
                    
                    // Эффект мерцания
                    let fadeActions = SKAction.sequence([
                        SKAction.fadeAlpha(to: 0.8, duration: 0.3),
                        SKAction.fadeAlpha(to: 1.0, duration: 0.3)
                    ])
                    let pulse = SKAction.repeatForever(fadeActions)
                    
                    let group = SKAction.group([moveAction, pulse])
                    let removeAction = SKAction.removeFromParent()
                    let sequence = SKAction.sequence([group, removeAction])
                    
                    soldier.run(sequence)
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration * 0.8) {
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
                
                // Плавное изменение цвета при захвате
                let fadeAction = SKAction.customAction(withDuration: 1.0) { node, elapsedTime in
                    let progress = elapsedTime / CGFloat(1.0)
                    if let territory = node as? TerritoryNode {
                        // Плавно меняем цвет от текущего к новому
                        if from.owner == .player {
                            let red = 0.2 * progress + (1 - progress) * (territory.owner == .enemy ? 0.9 : 0.5)
                            let green = 0.5 * progress + (1 - progress) * (territory.owner == .enemy ? 0.2 : 0.5)
                            let blue = 0.9 * progress + (1 - progress) * (territory.owner == .enemy ? 0.2 : 0.5)
                            territory.backgroundNode.color = SKColor(red: red, green: green, blue: blue, alpha: 0.3)
                        } else {
                            let red = 0.9 * progress + (1 - progress) * 0.5
                            let green = 0.2 * progress + (1 - progress) * 0.5
                            let blue = 0.2 * progress + (1 - progress) * 0.5
                            territory.backgroundNode.color = SKColor(red: red, green: green, blue: blue, alpha: 0.3)
                        }
                    }
                }
                to.run(fadeAction) {
                    to.updateTerritoryColor()
                    to.updateAppearance()
                }
            } else {
                to.soldiers -= soldiers
            }
        }
        
        // Обновляем цвет исходной территории
        from.updateTerritoryColor()
        checkGameEnd()

    }

    // Упрощенная territoryTapped без проверок на attackInProgress
    func territoryTapped(_ territory: TerritoryNode) {
        if selectedFromTerritory == nil {
            if territory.owner == .player {
                selectedFromTerritory = territory
                territory.isSelected = true
            }
        } else {
            guard territory != selectedFromTerritory else {
                selectedFromTerritory?.isSelected = false
                selectedFromTerritory = nil
                return
            }
            
            selectedToTerritory = territory
            launchAttack(from: selectedFromTerritory!, to: selectedToTerritory!)
            selectedFromTerritory?.isSelected = false
            selectedFromTerritory = nil
            selectedToTerritory = nil
        }
    }

    // Enemy AI может атаковать в любое время
    private func enemyAIAttack() {
        let enemyTerritories = territories.filter { $0.owner == .enemy && $0.soldiers > 1 }
        guard !enemyTerritories.isEmpty else { return }
        
        for _ in 0..<2 { // 2 атаки за раз для большей агрессивности
            guard let fromTerritory = enemyTerritories.randomElement() else { continue }
            
            let adjacentTerritories = findAdjacentTerritories(for: fromTerritory)
            let targetTerritories = adjacentTerritories.filter { $0.owner != .enemy }
            
            guard let toTerritory = targetTerritories.randomElement() else { continue }
            
            let soldiersToSend = min(fromTerritory.soldiers - 1, fromTerritory.soldiers / 2 + 1)
            fromTerritory.soldiers -= soldiersToSend
            
            animateSoldiersMovement(from: fromTerritory, to: toTerritory, count: soldiersToSend) {
                self.resolveAttack(from: fromTerritory, to: toTerritory, soldiers: soldiersToSend)
            }
        }
    }

    private func findAdjacentTerritories(for territory: TerritoryNode) -> [TerritoryNode] {
        return territories.filter { other in
            other != territory &&
            hypot(other.position.x - territory.position.x,
                  other.position.y - territory.position.y) < 100
        }
    }
        
    private func showGameOver(winner: TerritoryOwner) {
        // Создаем размытый фон
        let blurEffect = SKEffectNode()
        let blurFilter = CIFilter(name: "CIGaussianBlur")!
        blurFilter.setValue(10.0, forKey: "inputRadius")
        blurEffect.filter = blurFilter
        blurEffect.position = CGPoint(x: size.width/2, y: size.height/2)
        blurEffect.zPosition = 99
        addChild(blurEffect)
        
        // Добавляем оригинальное изображение с размытием
        let bgImage = SKSpriteNode(imageNamed: gameViewModel?.backgroundImage ?? "bg1")
        bgImage.size = self.size
        bgImage.position = CGPoint(x: size.width/2, y: size.height/2)
        blurEffect.addChild(bgImage)
        
        // Затемнение
        let darkOverlay = SKSpriteNode(color: .black, size: size)
        darkOverlay.alpha = 0.5
        darkOverlay.position = CGPoint(x: size.width/2, y: size.height/2)
        darkOverlay.zPosition = 100
        addChild(darkOverlay)
        
        // Основной контейнер
        let gameOverNode = SKNode()
        gameOverNode.position = CGPoint(x: size.width/2, y: size.height/2)
        gameOverNode.zPosition = 101
        addChild(gameOverNode)
        
        // Надпись победы/поражения
        let message = SKLabelNode(text: winner == .player ? "YOU WIN!" : "YOU LOSE!")
        message.fontName = "Avenir-Black"
        message.fontSize = 60
        message.fontColor = .white
        message.position = CGPoint(x: 0, y: 80)
        gameOverNode.addChild(message)
        
        // Кнопка
        let button = SKSpriteNode(imageNamed: "buttonBG")
        button.size = CGSize(width: 200, height: 80)
        button.position = CGPoint(x: 0, y: -40)
        button.name = winner == .player ? "take" : "back"
        gameOverNode.addChild(button)
        
        // Текст на кнопке - теперь точно по центру
        let buttonText = SKLabelNode(text: winner == .player ? "TAKE" : "BACK")
        buttonText.fontName = "Avenir-Black"
        buttonText.fontSize = 30
        buttonText.fontColor = .white
        buttonText.position = CGPoint(x: 0, y: 0) // Центрируем относительно кнопки
        buttonText.verticalAlignmentMode = .center
        buttonText.horizontalAlignmentMode = .center
        buttonText.name = button.name
        button.addChild(buttonText) // Добавляем текст как дочерний элемент кнопки
        
        // Анимация только для надписи (без анимации кнопки)
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 0.9, duration: 0.5)
        let pulse = SKAction.sequence([scaleUp, scaleDown])
        message.run(SKAction.repeatForever(pulse))
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        let touchedNodes = nodes(at: location)
        for node in touchedNodes {
            if node.name == "take" {
                // Добавляем 20 очков и закрываем экран
                gameData?.addCoins(20)
                dismissAction?()
            } else if node.name == "back" {
                // Просто закрываем экран
                dismissAction?()
            }
        }
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
            // Уровень пройден
            gameViewModel?.completeLevel(gameViewModel?.currentLevel ?? 1)
            showGameOver(winner: .player)
        }
    }
    
//    private func showVictory() {
//        let victoryNode = SKSpriteNode(color: .black.withAlphaComponent(0.7), size: size)
//        victoryNode.position = CGPoint(x: size.width/2, y: size.height/2)
//        victoryNode.zPosition = 100
//        addChild(victoryNode)
//        
//        
//        // Добавляем надпись "YOU WIN!" золотого цвета
//        let winLabel = SKLabelNode(text: "YOU WIN!")
//        winLabel.fontName = "Avenir-Black"
//        winLabel.fontSize = 60
//        winLabel.fontColor = SKColor(red: 1.0, green: 0.84, blue: 0.0, alpha: 1.0) // Золотой цвет
//        winLabel.position = CGPoint(x: 0, y: 50)
//        winLabel.zPosition = 102
//        victoryNode.addChild(winLabel)
//        
//        // Добавляем кнопку "Назад"
//        let backButton = SKLabelNode(text: "Back")
//        backButton.fontName = "Avenir-Medium"
//        backButton.fontSize = 30
//        backButton.fontColor = .white
//        backButton.position = CGPoint(x: 0, y: -50)
//        backButton.zPosition = 102
//        backButton.name = "back"
//        victoryNode.addChild(backButton)
//        
//        // Анимация для надписи
//        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
//        let scaleDown = SKAction.scale(to: 0.9, duration: 0.5)
//        let pulse = SKAction.sequence([scaleUp, scaleDown])
//        winLabel.run(SKAction.repeatForever(pulse))
//    }
    

    // MARK: - Вспомогательные методы для обработки изображения
    
    private func findRegions(in cgImage: CGImage) -> [[CGPoint]] {
        let width = cgImage.width
        let height = cgImage.height
        
        var visited = Array(repeating: Array(repeating: false, count: width), count: height)
        var regions: [[CGPoint]] = []
        
        func isPartOfRegion(x: Int, y: Int) -> Bool {
            guard x >= 0, x < width, y >= 0, y < height else { return false }
            let pixelColor = getPixelColor(cgImage: cgImage, x: x, y: y)
            let isWhite = pixelColor.r > 200 && pixelColor.g > 200 && pixelColor.b > 200
            return !isWhite && !visited[y][x]
        }
        
        func bfs(startX: Int, startY: Int) -> [CGPoint] {
            var queue = [(x: startX, y: startY)]
            var region: [CGPoint] = []
            visited[startY][startX] = true
            
            while !queue.isEmpty {
                let current = queue.removeFirst()
                region.append(CGPoint(x: current.x, y: current.y))
                
                for (dx, dy) in [(0,1), (1,0), (0,-1), (-1,0)] {
                    let nx = current.x + dx
                    let ny = current.y + dy
                    if isPartOfRegion(x: nx, y: ny) {
                        visited[ny][nx] = true
                        queue.append((x: nx, y: ny))
                    }
                }
            }
            return region
        }
        
        for y in 0..<height {
            for x in 0..<width {
                if isPartOfRegion(x: x, y: y) {
                    regions.append(bfs(startX: x, startY: y))
                }
            }
        }
        
        return regions
    }
    
    private func createTerritoryImage(from region: [CGPoint], in cgImage: CGImage) -> UIImage? {
        let minX = Int(region.min(by: { $0.x < $1.x })?.x ?? 0)
        let maxX = Int(region.max(by: { $0.x < $1.x })?.x ?? 0)
        let minY = Int(region.min(by: { $0.y < $1.y })?.y ?? 0)
        let maxY = Int(region.max(by: { $0.y < $1.y })?.y ?? 0)
        
        let width = maxX - minX + 1
        let height = maxY - minY + 1
        
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitmapInfo
        ) else { return nil }
        
        context.setFillColor(UIColor.clear.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        
        for point in region {
            let x = Int(point.x) - minX
            let y = Int(point.y) - minY
            
            let pixelColor = getPixelColor(cgImage: cgImage, x: Int(point.x), y: Int(point.y))
            context.setFillColor(
                UIColor(
                    red: CGFloat(pixelColor.r)/255.0,
                    green: CGFloat(pixelColor.g)/255.0,
                    blue: CGFloat(pixelColor.b)/255.0,
                    alpha: CGFloat(pixelColor.a)/255.0
                ).cgColor
            )
            context.fill(CGRect(x: x, y: y, width: 1, height: 1))
        }
        
        guard let territoryCGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: territoryCGImage)
    }
    
    private func calculateRegionCenter(_ region: [CGPoint]) -> CGPoint {
        let minX = region.min(by: { $0.x < $1.x })?.x ?? 0
        let maxX = region.max(by: { $0.x < $1.x })?.x ?? 0
        let minY = region.min(by: { $0.y < $1.y })?.y ?? 0
        let maxY = region.max(by: { $0.y < $1.y })?.y ?? 0
        
        return CGPoint(x: (minX + maxX)/2, y: (minY + maxY)/2)
    }
    
    private func getPixelColor(cgImage: CGImage, x: Int, y: Int) -> (r: UInt8, g: UInt8, b: UInt8, a: UInt8) {
        let width = cgImage.width
        let height = cgImage.height
        
        guard x >= 0, x < width, y >= 0, y < height else { return (0,0,0,0) }
        
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitmapInfo = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        
        var pixelData = [UInt8](repeating: 0, count: 4)
        let context = CGContext(
            data: &pixelData,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: bytesPerRow,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: bitmapInfo
        )
        
        context?.draw(cgImage, in: CGRect(x: -x, y: -y, width: width, height: height))
        
        return (pixelData[0], pixelData[1], pixelData[2], pixelData[3])
    }
    
    private func calculateAverageColor(for region: [CGPoint], in cgImage: CGImage) -> UIColor? {
        var totalRed: CGFloat = 0
        var totalGreen: CGFloat = 0
        var totalBlue: CGFloat = 0
        var totalAlpha: CGFloat = 0
        
        for point in region {
            let pixelColor = getPixelColor(cgImage: cgImage, x: Int(point.x), y: Int(point.y))
            totalRed += CGFloat(pixelColor.r) / 255.0
            totalGreen += CGFloat(pixelColor.g) / 255.0
            totalBlue += CGFloat(pixelColor.b) / 255.0
            totalAlpha += CGFloat(pixelColor.a) / 255.0
        }
        
        let count = CGFloat(region.count)
        return UIColor(
            red: totalRed / count,
            green: totalGreen / count,
            blue: totalBlue / count,
            alpha: totalAlpha / count
        )
    }

    private func isPlayerColor(_ color: UIColor) -> Bool {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return blue > 0.5 && blue > red * 1.5 && blue > green * 1.5
    }

    private func isEnemyColor(_ color: UIColor) -> Bool {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return red > 0.5 && red > blue * 1.5 && red > green * 1.5
    }
}


// Добавляем это расширение для удобного получения позиции в сцене
extension SKNode {
    var positionInScene: CGPoint {
        if let parent = parent {
            return parent.convert(position, to: scene!)
        } else {
            return position
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
