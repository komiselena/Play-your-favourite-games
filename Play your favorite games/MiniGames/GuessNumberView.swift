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
                
                    // Игровое поле
                    VStack {

                        ZStack{
                            Image("bar")
                                .resizable()
                                .scaledToFill()
                                .frame(width:  g.size.width * 0.8, height: g.size.height * 0.7)

                            if game.isWon{
                                VStack(){
                                        HStack(spacing: 10) {
                                            ForEach(0..<3, id: \.self) { index in
                                                ZStack {
                                                    RoundedRectangle(cornerRadius: 14)
                                                        .foregroundStyle(Color(UIColor(hex: "#FDF6E4")))
                                                        .frame(width: g.size.width * 0.09, height: g.size.width * 0.09)
                                                    
                                                    if index < game.guess.count {
                                                        Text(String(game.guess[game.guess.index(game.guess.startIndex, offsetBy: index)]))
                                                            .font(.system(size: 37, weight: .bold))
                                                            .foregroundColor(.black)
                                                    }
                                                }
                                            }
                                        }
                                        .frame(width: g.size.width * 0.6, height: g.size.width * 0.2)
                                        Spacer()

                                    Text("NICE GUESS!")
                                        .foregroundStyle(Color(UIColor(hex: "#FFF6E2")))
                                        .font(.title)
                                    HStack{
                                        ZStack{
                                            Rectangle()
                                                .foregroundStyle(Color(UIColor(hex: "#4B2A28")))
                                                .frame(width: g.size.width * 0.18, height: g.size.height * 0.12)
                                                
                                            HStack(spacing: 5){
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

                            }else{
                                
                                VStack{
                                    HStack(spacing: 10) {
                                        ForEach(0..<3, id: \.self) { index in
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 14)
                                                    .foregroundStyle(Color(UIColor(hex: "#FDF6E4")))
                                                    .frame(width: g.size.width * 0.09, height: g.size.width * 0.09)
                                                
                                                if index < game.guess.count {
                                                    Text(String(game.guess[game.guess.index(game.guess.startIndex, offsetBy: index)]))
                                                        .font(.system(size: 37, weight: .bold))
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                    }
                                    .frame(width: g.size.width * 0.6, height: g.size.width * 0.2)
                                    Spacer()
                                    
                                    // Подсказка
                                    Group{
                                        if !game.hint.isEmpty {
                                            Text(game.hint)
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .padding()
                                                .animation(.easeInOut, value: game.hint)
                                            
                                        } else{
                                            Text("")
                                            
                                        }
                                    }
                                    .frame(width: g.size.width * 0.9, height: g.size.height * 0.05)
                                    
                                    
                                    Spacer()
                                    HStack(spacing: 10) {
                                        
                                        // Цифровая клавиатура
                                        VStack(spacing: 10) {
                                            ForEach(0..<2, id: \.self) { row in
                                                HStack(spacing: 10) {
                                                    ForEach(0..<5, id: \.self) { col in
                                                        let number = row * 5 + col
                                                        Button {
                                                            if game.guess.count < 5 && !game.isWon {
                                                                game.guess += "\(number)"
                                                                checkIfComplete()
                                                            }
                                                        } label: {
                                                            Text("\(number)")
                                                                .foregroundColor(.white)
                                                                .font(.title.weight(.bold))
                                                                .frame(width: g.size.width * 0.07, height: g.size.width * 0.07)
                                                                .background(content: {
                                                                    RoundedRectangle(cornerRadius: 18)
                                                                        .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))

                                                                })
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        // Последний ряд (только 0 по центру)
                                        
                                        Button {
                                            if !game.guess.isEmpty && !game.isWon {
                                                game.guess.removeLast()
                                            }
                                        } label: {
                                            Image(systemName: "delete.left")
                                                .foregroundColor(.white)
                                                .font(.title.weight(.bold))
                                                .frame(width: g.size.width * 0.07, height: g.size.width * 0.07)
                                                .background(content: {
                                                    RoundedRectangle(cornerRadius: 18)
                                                        .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))

                                                })
                                        }
                                    }
                                }
                                .frame(width:  g.size.width * 0.6, height: g.size.height * 0.5)
                                .padding(.bottom, g.size.height * 0.1)
                            }
                        }
                        .frame(width: g.size.width * 0.9, height: g.size.height * 0.6)
                        .overlay(
                            Button{
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
                                .padding(.bottom, g.size.height * 0.1)

                            ,alignment: .topTrailing
                        )

                    
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)


            }
            .frame(width: g.size.width , height: g.size.height )

            .onChange(of: game.isWon) { newValue in
                if game.isWon == true{
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


