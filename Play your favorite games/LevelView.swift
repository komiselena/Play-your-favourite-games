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
        GridItem(.flexible()),
        GridItem(.flexible())

    ]
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 5)

                VStack {
                    HStack(spacing: 0) {
                        Button {
                            dismiss()
                        } label: {
                            Image("arrow")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(Angle(degrees: -90))
                                .frame(width: g.size.width * 0.15, height: g.size.height * 0.15)
                        }
                        
                        Spacer()
                        
                        Text("LEVELS")
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.bold))
                        
                        Spacer()
                        
                        Button {
                            dismiss()
                        } label: {
                            Image("arrow")
                                .resizable()
                                .scaledToFit()
                                .rotationEffect(Angle(degrees: -90))
                                .frame(width: g.size.width * 0.15, height: g.size.height * 0.15)
                                .opacity(0.0)
                        }
                    }
                    .padding(.top, g.size.height * 0.1)
                    .frame(width: g.size.width, height: g.size.height * 0.1)

                    
                    Spacer()
                    
                    // Панель информации

                        VStack(spacing: 5) {
                            // Сетка уровней
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(1..<9) { level in
                                    Button {
                                        if level <= gameViewModel.unlockedLevels {
                                            selectedLevel = level
                                            gameViewModel.currentLevel = level
                                            gameViewModel.map = "map\(level)"
                                            isLevelSelected = true
                                        }
                                    } label: {
                                        ZStack {
                                            Image("card")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.23, height: g.size.height * 0.23)
                                            
                                            Text("\(level)")
                                                .font(.system(size: 40, weight: .bold))
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
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
            }
            .fullScreenCover(isPresented: $isLevelSelected) {
                ContentView(gameViewModel: gameViewModel)
            }
        }
        .navigationBarBackButtonHidden()
    }
}
