//
//  ShopView.swift
//  Tachi Palace game
//
//  Created by Mac on 20.05.2025.
//

import SwiftUI

struct ShopView: View {
    @State private var bgChosen: Bool = true
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @State private var currentIndex: Int = 0
    
    let backgrounds = ["shopbg1", "shopbg2", "shopbg3", "shopbg4"]
    let backgroundPrices = [100, 100, 100, 100]
    
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
                        
                        Text("SHOP")
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
                    
                    VStack {
                        ZStack {
                            Image("buttonBG")
                                .resizable()
                                .scaledToFit()
                                .frame(width: g.size.width * 0.17, height: g.size.height * 0.17)
                            
                            HStack(spacing: 5) {
                                Image("coin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.03, height: g.size.width * 0.03)
                                
                                Text("\(gameData.coins)")
                                    .foregroundStyle(.white)
                                    .font(.title3.weight(.bold))
                            }
                            .frame(width: g.size.width * 0.17, height: g.size.height * 0.17)
                        }
                        
                        // Карусель фонов
                        HStack {
                            Button {
                                withAnimation {
                                    currentIndex = (currentIndex - 1 + backgrounds.count) % backgrounds.count
                                }
                            } label: {
                                Image("arrow")
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(Angle(degrees: -90))
                                    .frame(width: g.size.width * 0.15, height: g.size.height * 0.15)
                            }
                            
                            // Боковое маленькое изображение (предыдущее)
                            if backgrounds.count > 1 {
                                let prevIndex = (currentIndex - 1 + backgrounds.count) % backgrounds.count
                                Image(backgrounds[prevIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .opacity(0.7)
                                    .padding(.horizontal)
                            }
                            
                            // Центральное большое изображение
                            Image(backgrounds[currentIndex])
                                .resizable()
                                .scaledToFill()
                                .frame(width: g.size.width * 0.3, height: g.size.width * 0.3)
                                .padding(.horizontal, 10)
                            
                            // Боковое маленькое изображение (следующее)
                            if backgrounds.count > 1 {
                                let nextIndex = (currentIndex + 1) % backgrounds.count
                                Image(backgrounds[nextIndex])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .opacity(0.7)
                                    .padding(.horizontal)
                            }
                            
                            Button {
                                withAnimation {
                                    currentIndex = (currentIndex + 1) % backgrounds.count
                                }
                            } label: {
                                Image("arrow")
                                    .resizable()
                                    .scaledToFit()
                                    .rotationEffect(Angle(degrees: 90))
                                    .frame(width: g.size.width * 0.15, height: g.size.height * 0.15)
                            }
                        }
                        .frame(height: g.size.height * 0.3)
                        
                        // Кнопка действия для текущего фона
                        Button {
                            handleBGButton(id: currentIndex + 1) // +1 потому что у вас id начинаются с 1
                        } label: {
                            ZStack {
                                Image("buttonBG")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.5, height: g.size.height * 0.16)
                                
                                Text(currentBGButtonImage(for: currentIndex + 1))
                                    .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                    .font(.headline.weight(.bold))
                            }
                        }
                        .padding(.top, 20)
                    }
                    
                    Spacer()
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
            }
            .frame(width: g.size.width, height: g.size.height)
        }
        .navigationBarBackButtonHidden()
    }
    
    private func handleBGButton(id: Int) {
        if gameData.boughtBackgroundId.contains(id) {
            gameViewModel.backgroundImage = "bg\(id)"
            gameViewModel.objectWillChange.send()
        } else {
            if gameData.coins >= 100 {
                gameData.coins -= 100
                gameData.boughtBackgroundId.append(id)
            } else {
                print("Not enough money")
            }
        }
    }

    private func currentBGButtonImage(for id: Int) -> String {
        if gameData.boughtBackgroundId.contains(id) && gameViewModel.backgroundImage != "bg\(id)" {
            return "CHOOSE"
        } else if gameViewModel.backgroundImage == "bg\(id)" {
            return "CHOSEN"
        } else {
            return "100"
        }
    }
}
