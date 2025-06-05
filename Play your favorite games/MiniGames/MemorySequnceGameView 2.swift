//
//  MemorySequnceGameView 2.swift
//  Play your favorite games
//
//  Created by Mac on 05.06.2025.
//


//
//  MemorySequnceGameView.swift
//  Lucky Eagle Game
//
//  Created by Mac on 27.04.2024.
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
                    .blur(radius: 5)

                VStack(spacing: 10) {
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
                        
                        Text("REPEAT THE SEQUENCE")
                            .foregroundStyle(.white)
                            .font(.title.weight(.bold))

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

                    // Game content
                    ZStack {
                        if viewModel.isGameOver {
                            if viewModel.isWon {
                                winView(g: g)
                            } else {
                                loseView(g: g)
                            }
                        } else {
                            gameContentView(g: g)
                        }
                    }
                    
                    Spacer()
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
            }
            .frame(width: g.size.width, height: g.size.height)
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
    
    // MARK: - Subviews
    
    private func gameContentView(g: GeometryProxy) -> some View {
        VStack(spacing: 20) {
            // Central card display area
            ZStack {
                if viewModel.showingSequence {
                    // Show current sequence card
                    if let card = viewModel.showCard {
                        centralCardView(card: card, g: g)

                    }
                } else {
                    // Show user's selected cards
                    if !viewModel.userInput.isEmpty {
                        centralCardView(card: viewModel.userInput.last!, g: g)
                    } else {
                        // Empty space when no cards selected
                        Color.clear
                            .frame(height: g.size.height * 0.3)
                    }
                }
            }
            .frame(height: g.size.height * 0.3)
            
            // Sequence progress indicator - only show when user has made at least one input
            
            // All available cards at the bottom in a single row
            HStack(spacing: 10) {
                ForEach(["card1", "card2", "card3", "card4", "card5", "card6", "card7"], id: \.self) { card in
                    Button {
                        if !viewModel.showingSequence {
                            viewModel.selectCard(card)
                        }
                    } label: {
                        Image(card)
                            .resizable()
                            .scaledToFit()
                            .frame(width: g.size.width * 0.1, height: g.size.width * 0.1) // Smaller size
                    }
                    .disabled(viewModel.showingSequence)
                }
            }
            .frame(width: g.size.width * 0.9)
            .padding(.top, g.size.height * 0.1)
        }
    }
    
    private func centralCardView(card: String, g: GeometryProxy) -> some View {
        ZStack {
            Image(card)
                .resizable()
                .scaledToFit()
                .frame(width: g.size.width * 0.2, height: g.size.width * 0.2)
        }
    }
    
    private func winView(g: GeometryProxy) -> some View {
        VStack {
            Image("stars")
                .resizable()
                .scaledToFit()
                .frame(width: g.size.width * 0.4, height: g.size.height * 0.3)
                        
            HStack {
                Button {
                    dismiss()
                } label: {
                    ZStack {
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
    }
    
    private func loseView(g: GeometryProxy) -> some View {
        VStack {
            HStack(spacing: 10) {
                ForEach(viewModel.sequence, id: \.self) { card in
                    Image(card)
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 0.08, height: g.size.width * 0.08)
                }
            }
                        
            HStack {
                Button {
                    dismiss()
                } label: {
                    ZStack {
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
    }
}

#Preview {
    MemorySequnceGameView(gameData: GameData(), gameViewModel: GameViewModel())
}
