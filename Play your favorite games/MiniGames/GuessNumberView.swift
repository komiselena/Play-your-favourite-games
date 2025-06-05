//
//  GuessNumberView.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import SwiftUI

struct GuessNumberView: View {
    @ObservedObject var gameData: GameData
    @Environment(\.dismiss) private var dismiss
    @StateObject private var game = GuessTheNumberGame()
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 5)

                // Игровое поле
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
                        
                        // Измененный заголовок - показывает подсказку или название игры
                        if game.hint.isEmpty {
                            Text("GUESS THE NUMBER")
                                .foregroundStyle(.white)
                                .font(.largeTitle.weight(.bold))
                        } else {
                            Text(game.hint)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .animation(.easeInOut, value: game.hint)
                        }
                        
                        Spacer()
                        
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
                    }
                    .padding(.top, g.size.height * 0.1)
                    .frame(width: g.size.width, height: g.size.height * 0.1)
                    
                    Spacer()
                    
                    if game.isWon {
                        VStack {
                            // Новый дизайн для отображения числа - на фоне изображения
                            ZStack {
                                Image("buttonBG") // Замените на ваше изображение
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.5)
                                
                                HStack(spacing: 10) {
                                    ForEach(0..<3, id: \.self) { index in
                                        if index < game.guess.count {
                                            Text(String(game.guess[game.guess.index(game.guess.startIndex, offsetBy: index)]))
                                                .font(.system(size: 50, weight: .bold))
                                                .foregroundColor(.white)
                                        }
                                    }
                                }
                                .padding(.bottom, 20)
                            }
                            
                            Spacer()
                            
                            HStack {
                                ZStack {
                                    Rectangle()
                                        .foregroundStyle(Color(UIColor(hex: "#4B2A28")))
                                        .frame(width: g.size.width * 0.18, height: g.size.height * 0.12)
                                    
                                    HStack(spacing: 5) {
                                        Image("coin")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                        
                                        Text("+20")
                                            .foregroundStyle(.white)
                                            .font(.title2.weight(.bold))
                                    }
                                    .padding(.trailing, g.size.width * 0.05)
                                }
                                .frame(width: g.size.width * 0.3, height: g.size.height * 0.1)
                            }
                        }
                        .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)
                    } else {
                        VStack {
                            // Новый дизайн для ввода числа - на фоне изображения
                            ZStack {
                                Image("back")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.68)

                                HStack(spacing: 10) {
                                    ForEach(0..<3, id: \.self) { index in
                                        if index < game.guess.count {
                                            Text(String(game.guess[game.guess.index(game.guess.startIndex, offsetBy: index)]))
                                                .font(.system(size: 40, weight: .bold))
                                                .foregroundColor(.white)
                                        } else {
                                            Text("")
                                                .font(.system(size: 50, weight: .bold))
                                                .foregroundColor(.white.opacity(0.5))
                                        }
                                    }
                                }
                                .padding(.top, g.size.height * 0.1)
                                .frame(width: g.size.width * 0.2)

                                .padding(.bottom, 20)
                            }
                            
                            Spacer()
                            HStack(spacing: 10){
                                // Цифровая клавиатура
                                VStack(spacing: 10) {
                                    ForEach(0..<2, id: \.self) { row in
                                        HStack(spacing: 10) {
                                            ForEach(0..<5, id: \.self) { col in
                                                let number = row * 5 + col
                                                Button {
                                                    if game.guess.count < 3 && !game.isWon {
                                                        game.guess += "\(number)"
                                                        checkIfComplete()
                                                    }
                                                } label: {
                                                    Text("\(number)")
                                                        .foregroundColor(.white)
                                                        .font(.title.weight(.bold))
                                                        .frame(width: g.size.width * 0.09, height: g.size.width * 0.09)
                                                        .background(content: {
                                                            Image("card")
                                                                .resizable()
                                                                .scaledToFit()
                                                        })
                                                }
                                            }
                                            // Кнопка удаления
                                            
                                        }
                                    }
                                    
                                }
                                Button {
                                    if !game.guess.isEmpty && !game.isWon {
                                        game.guess.removeLast()
                                    }
                                } label: {
                                    Image(systemName: "delete.left")
                                        .foregroundColor(.white)
                                        .font(.title.weight(.bold))
                                        .frame(width: g.size.width * 0.09, height: g.size.width * 0.09)
                                        .background(content: {
                                            Image("card")
                                                .resizable()
                                                .scaledToFit()
                                        })
                                }

                            }
                        }
                        .frame(width: g.size.width * 0.7, height: g.size.height * 0.8)
                        .padding(.bottom, g.size.height * 0.1)
                    }
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
            }
            .frame(width: g.size.width, height: g.size.height)
            .onChange(of: game.isWon) { newValue in
                if game.isWon {
                    gameData.addCoins(20)
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    private func checkIfComplete() {
        if game.guess.count == 3 {
            game.checkGuess()
        }
    }
}
