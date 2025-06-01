//
//  MemorySequnceGameView.swift
//  Lucky Eagle Game
//
//  Created by Mac on 27.04.2025.
//


import SwiftUI

struct MemorySequnceGameView: View {
    @StateObject private var viewModel = MemoryGameViewModel()
    @ObservedObject var gameData: GameData
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        GeometryReader { g in
            ZStack{
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                

                VStack(spacing: 10) {
                    ZStack{
                        Image("bar")
                            .resizable()
                            .scaledToFill()
                            .frame(width:  g.size.width * 0.8, height: g.size.height * 0.7)

                        
                        if viewModel.isGameOver && viewModel.isWon == false {
                            VStack{
                                HStack(spacing: 5) {
                                    ForEach(0..<viewModel.sequence.count, id: \.self) { index in
                                        ZStack {
                                            // Фон - пустой квадрат
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.white)
                                                .opacity(0.5)
                                                .frame(width: g.size.width * 0.08, height: g.size.width * 0.08)
                                            
                                            // Если пользователь уже ввел карточку на этой позиции - показываем ее
                                            if index < viewModel.userInput.count {
                                                Image(viewModel.userInput[index])
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width * 0.06, height: g.size.width * 0.06)
                                            }
                                        }
                                    }
                                }
                                .frame(height: g.size.width * 0.08)

                                Text("Incorrect!!!")
                                    .foregroundStyle(.white)
                                    .font(.title)
                                HStack{
                                    Button {
                                        dismiss()
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.25, height: g.size.width * 0.1)
                                            Text("Retry")
                                                .font(.title)
                                                .foregroundStyle(.white)
                                        }

                                    }

                                }
                            }
                            .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)

                        } else if viewModel.isGameOver && viewModel.isWon {
                            VStack(){
                                Image("stars")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.4, height: g.size.height * 0.3)

                                Text("You Win!")
                                    .foregroundStyle(.white)
                                    .font(.title)
                                HStack{
                                    Button {
                                        dismiss()
                                    } label: {
                                        ZStack{
                                            Circle()
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                            Image(systemName: "house")
                                                .font(.title)
                                                .foregroundStyle(.white)
                                        }
                                    }


                                }
                            }
                            .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)


                        } else {
                            VStack(spacing: 0) {
                                if viewModel.showingSequence {
                                    if let card = viewModel.showCard {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: g.size.width * 0.3, height: g.size.width * 0.2)
                                                .foregroundStyle(Color(UIColor(hex: "#FDF6E4")))
                                            Image(card)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.15, height:  g.size.width * 0.15)
                                                .transition(.scale)
                                        }
                                    }
                                } else {
                                    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                                    
                                    VStack {
                                        // Отображаем ряд квадратов по количеству элементов в последовательности
                                        HStack{
                                            Text("SIMON SAYS")
                                                .foregroundStyle(.yellow)
                                                .font(.headline.weight(.bold))
                                            Spacer()
                                            HStack(spacing: 5) {
                                                ForEach(0..<viewModel.sequence.count, id: \.self) { index in
                                                    ZStack {
                                                        // Фон - пустой квадрат
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundStyle(.white)
                                                            .opacity(0.7)
                                                            .frame(width: g.size.width * 0.08, height: g.size.width * 0.08)
                                                        
                                                        // Если пользователь уже ввел карточку на этой позиции - показываем ее
                                                        if index < viewModel.userInput.count {
                                                            Image(viewModel.userInput[index])
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: g.size.width * 0.06, height: g.size.width * 0.06)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .frame(width: g.size.width * 0.7)
                                        
                                        
                                        LazyVGrid(columns: columns) {
                                            ForEach(["card1", "card2", "card3", "card4", "card5", "card6", "coin", "inde"], id: \.self) { card in
                                                Button {
                                                    viewModel.selectCard(card)
                                                } label: {
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundStyle(Color(UIColor(hex: "#FDF6E4")))
                                                            .frame(width: g.size.width * 0.09, height: g.size.width * 0.09)
                                                        
                                                        Image(card)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: g.size.width * 0.07, height: g.size.width * 0.07)
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        .frame(width: g.size.width * 0.6, height: g.size.height * 0.4)
                                    }
                                    
                                }
                            }
                            .frame(height: g.size.height * 0.6)
                        }
                    }
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
                        
                        ,alignment: .topTrailing
                    )

                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)


            }

            
            .frame(width: g.size.width , height: g.size.height)
            .onChange(of: viewModel.isWon) { newValue in
                if viewModel.isGameOver && viewModel.isWon {
                    gameData.addCoins(30)
                }
            }

            
            .onAppear {
                viewModel.startGame()
            }
            .animation(.easeInOut, value: viewModel.showCard)
            
            
            
        }

        .navigationBarBackButtonHidden()

    }
}


#Preview {
    MemorySequnceGameView(gameData: GameData(), gameViewModel: GameViewModel())
}
