//
//  LevelView.swift
//  Play your favorite games
//
//  Created by Mac on 02.06.2025.
//

import SwiftUI

struct LevelView: View {
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @State private var selectedLevel: Int = 1
    @State private var isLevelSelected: Bool = false
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    HStack(spacing: 0) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.white)
                                .font(.title.weight(.bold))
                                .padding(5)
                                .background {
                                    Circle()
                                        .foregroundStyle(.red)
                                }
                        }
                        
                        Spacer()
                        
                        Text("LEVELS")
                            .foregroundStyle(.white)
                            .font(.title.weight(.bold))
                        
                        Spacer()
                        
                        // Невидимая кнопка для балансировки
                        Button {} label: {
                            Image(systemName: "xmark")
                                .foregroundStyle(.clear)
                                .font(.title.weight(.bold))
                                .padding(5)
                                .background {
                                    Circle()
                                        .foregroundStyle(.clear)
                                }
                        }
                    }
                    .padding(.top, g.size.height * 0.1)
                    .frame(height: g.size.height * 0.1)
                    
                    Spacer()
                    
                    // Панель информации
                    ZStack {
                        Image("bar")
                            .resizable()
                            .scaledToFill()
                            .frame(width: g.size.width * 0.8, height: g.size.height * 0.7)

                        VStack(spacing: 5) {
                            Text("CURRENT LEVEL")
                                .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))
                                .font(.caption.weight(.bold))
                            
                            Text("\(gameViewModel.currentLevel)")
                                .foregroundStyle(.white)
                                .font(.title.weight(.bold))
                            
                            Text("UNLOCKED: \(gameViewModel.unlockedLevels)/6")
                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                .font(.caption.weight(.bold))
                            
                            // Сетка уровней
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(1..<7) { level in
                                    Button {
                                        if level <= gameViewModel.unlockedLevels {
                                            selectedLevel = level
                                            gameViewModel.currentLevel = level
                                            gameViewModel.map = "map\(level)"
                                            isLevelSelected = true
                                        }
                                    } label: {
                                        ZStack {
                                            Circle()
                                                .foregroundStyle(level <= gameViewModel.unlockedLevels ?
                                                               Color(UIColor(hex: "#8FC7F9")) : Color.gray)
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                                .shadow(color: .white.opacity(0.5), radius: 10)
                                            
                                            Text("\(level)")
                                                .font(.system(size: 30, weight: .bold))
                                                .foregroundColor(.white)
                                            
                                            if level > gameViewModel.unlockedLevels {
                                                Image(systemName: "lock.fill")
                                                    .font(.title)
                                                    .foregroundColor(.white)
                                            }
                                        }
                                    }
                                    .disabled(level > gameViewModel.unlockedLevels)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
            }
            .fullScreenCover(isPresented: $isLevelSelected) {
                ContentView(gameViewModel: gameViewModel)
            }
        }
        .navigationBarBackButtonHidden()
    }
}
