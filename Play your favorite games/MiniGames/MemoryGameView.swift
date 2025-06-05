//
//  MemoryMatchView.swift
//  Lucky Eagle Game
//
//  Created by Mac on 26.04.2025.
//

import SwiftUI

struct MemoryGameView: View {
    @StateObject private var game = MemoryGame(images: ["card1", "card2", "card3", "card4", "card5", "card6"])
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameData: GameData
    @State private var remainingAttempts = 5
    @State private var timeLeft = 45
    @State private var showReward = false
    @State private var timer: Timer?
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        GeometryReader { g in
            ZStack {
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 5)

                VStack {
                    // Header
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
                        
                        if game.allMatchesFound {
                            Text("ALL MATCHES ARE FOUND")
                                .foregroundStyle(.white)
                                .font(.title.weight(.bold))

                        } else if game.lostMatch {
                            Text("MATCHES ARE INCORRECT")
                                .foregroundStyle(.white)
                                .font(.title.weight(.bold))

                        } else {
                            Text("FIND A MATCH")
                                .foregroundStyle(.white)
                                .font(.title.weight(.bold))
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
                    
                    // Game stats
                    HStack {
                        ZStack {
                            Image("back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: g.size.width * 0.15)
                            
                            Text("Tries: \(remainingAttempts)")
                                .foregroundStyle(.white)
                                .font(.headline.weight(.bold))
                                .padding(.top, g.size.height * 0.05)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Image("back")
                                .resizable()
                                .scaledToFit()
                                .frame(width: g.size.width * 0.15)
                            
                            Text("Time: \(timeLeft)")
                                .foregroundStyle(.white)
                                .font(.headline.weight(.bold))
                                .padding(.top, g.size.height * 0.05)

                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(width: g.size.width * 0.6)
                    
                    Spacer()
                    
                    // Game content
                    if game.lostMatch {
                        lostMatchView(g: g)
                    } else if game.allMatchesFound {
                        winView(g: g)
                    } else {
                        cardsGridView(g: g)
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden()
    }
    
    // MARK: - Subviews
    
    private func cardsGridView(g: GeometryProxy) -> some View {
        VStack(spacing: 10) {
            // 2 rows with 6 columns each
            ForEach(0..<2, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(0..<6, id: \.self) { col in
                        let index = row * 6 + col
                        if index < game.cards.count {
                            CardView(card: game.cards[index], geometry: g)
                                .onTapGesture {
                                    handleCardTap(index)
                                }
                        }
                    }
                }
            }
        }
        .frame(width: g.size.width * 0.9)
    }
    
    private func winView(g: GeometryProxy) -> some View {
        VStack {
            Text("ALL CARDS ARE MATCHED")
                .foregroundStyle(.white)
                .font(.title)
            
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
    }
    
    private func lostMatchView(g: GeometryProxy) -> some View {
        VStack {
            Text("CARDS ARE NOT MATCHED")
                .foregroundStyle(Color(UIColor(hex: "#FFF6E2")))
                .font(.title)
            
            HStack {
                Button {
                    game.restartGame()
                    remainingAttempts = 5
                } label: {
                    ZStack {
                        Image("buttonBG")
                            .resizable()
                            .scaledToFit()
                            .frame(width: g.size.width * 0.38, height: g.size.height * 0.2)
                        Text("RETRY")
                            .font(.title)
                            .foregroundStyle(Color(UIColor(hex: "#FAAD08")))
                    }
                }
            }
        }
        .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)
    }
    
    // MARK: - Game Logic
    
    private func handleCardTap(_ index: Int) {
        guard !showReward else { return }
        
        let previousMatched = game.cards.filter { $0.isMatched }.count
        game.flipCard(at: index)
        let currentMatched = game.cards.filter { $0.isMatched }.count
        
        if currentMatched == previousMatched && game.indexOfFirstCard == nil {
            remainingAttempts -= 1
        }
        
        checkGameEnd()
    }
    
    private func checkGameEnd() {
        if game.cards.allSatisfy({ $0.isMatched }) {
            game.allMatchesFound = true
            gameData.addCoins(30)
        } else if remainingAttempts <= 0 {
            game.lostMatch = true
        }
    }
}

struct CardView: View {
    var card: Card
    @State private var flipped = false
    @State private var rotation = 0.0
    @State private var scale = 1.0
    var geometry: GeometryProxy
    
    var body: some View {
        ZStack {
            Group {
                if flipped {
                    // Front side of the card (image)
                    Image(card.imageName)
                        .resizable()
                        .scaledToFit()
                } else {
                    // Back side of the card
                    Image("card")
                        .resizable()
                        .scaledToFit()
                }
            }
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(scale)
        }
        .frame(width: geometry.size.width * 0.12, height: geometry.size.width * 0.12)
        .onChange(of: card.isFlipped || card.isMatched) { newValue in
            flipCard(to: newValue)
        }
    }
    
    private func flipCard(to isFlipped: Bool) {
        withAnimation(.easeInOut(duration: 0.2)) {
            rotation = 90
            scale = 1.05
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            flipped = isFlipped
            withAnimation(.easeInOut(duration: 0.2)) {
                rotation = 0
                scale = 1.0
            }
        }
    }
}
