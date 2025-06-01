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
            ZStack{
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .ignoresSafeArea()

                
                mainContent(g: g)

            }
            
            .frame(width: g.size.width , height: g.size.height)


        }

        .navigationBarBackButtonHidden()
    }
    
        // MARK: - Subviews

    private func mainContent(g: GeometryProxy) -> some View {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad

        return VStack{

            ZStack{
                Image("bar")
                    .resizable()
                    .scaledToFill()
                    .frame(width:  g.size.width * 0.8, height: g.size.height * 0.7)
                if game.lostMatch {
                    VStack(){
                        livesView(geometry: g)
                        Text("CARDS ARE NOT MACTHED")
                            .foregroundStyle(Color(UIColor(hex: "#FFF6E2")))
                            .font(.title)
                        HStack{
                            Button {
                                game.restartGame()
                            } label: {
                                ZStack{
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

                } else if game.allMatchesFound{
                    VStack(){
                        Text("ALL CARDS ARE MATCHED")
                            .foregroundStyle(.white)
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

                } else{
                    VStack{
                        livesView(geometry: g)
                        cardsGridView(geometry: g)
                            .scaleEffect(isIPad ? 0.8 : 1.0)
                    }
                    .frame(width: g.size.width * 0.6, height: g.size.height * 0.5)

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
        .frame(height: g.size.height * 0.9)


    }
    
    
    private func livesView(geometry: GeometryProxy) -> some View {
        HStack(spacing: 0) {
            Text("Match the cards")
                .textCase(.uppercase)
                .foregroundStyle(.yellow)
                .font(.headline)
                .hLeading()

            HStack(spacing: 8){
                ForEach(0..<5, id: \.self) { index in
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .opacity(0.5)
                            .frame(width: geometry.size.width * 0.04, height: geometry.size.width * 0.04)
                        Image(systemName: "xmark")
                            .font(.title.weight(.bold))
                            .foregroundStyle(index < remainingAttempts ? .gray : .red)
                    }
                }
            }

        }
        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.2)

    }
    
    private func cardsGridView(geometry: GeometryProxy) -> some View {
        VStack {
            let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(Array(game.cards.enumerated()), id: \.element.id) { index, card in
                    CardView(card: card, geometry: geometry)
                        .onTapGesture {
                            handleCardTap(index)
                        }
                }
            }
        }
        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.4)
    }


    private func overlayViews(g: GeometryProxy) -> some View {
        Group {
            if game.lostMatch {
                lostMatchView(g: g)
            } else if game.allMatchesFound {
                ZStack{
                    Color.black
                        .opacity(0.5)
                        .ignoresSafeArea()
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: g.size.width * 0.7, height: g.size.height * 0.5)
                        VStack{
                            Text("You Win")
                                .foregroundStyle(.white)
                                .font(.system(size: 34, weight: .bold))
                                .padding()
                            Text("Your Score:")
                                .foregroundStyle(.white)
                                .font(.callout)
                            HStack{
                                Text("20")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 28, weight: .bold))
                                Image("coin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.15, height: g.size.width * 0.15)
                            }
                            .frame(width: g.size.width * 0.5)
                            Button {
                                dismiss()
                                gameData.addCoins(20)
                            } label: {
                                ZStack{
                                    Capsule()
                                        .foregroundStyle(.white)
                                        .frame(width: g.size.width * 0.6, height: g.size.width * 0.15)
                                    Text("Claim")
                                        .foregroundStyle(.black)
                                        .font(.system(size: 24, weight: .bold))
                                    
                                    
                                }
                                
                            }
                            
                            
                            
                        }
                        .frame(width: g.size.width * 0.7, height: g.size.height * 0.5)
                        
                    }
                }


            }
        }
    }
    
    private func lostMatchView(g: GeometryProxy) -> some View {
        ZStack{
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            ZStack{
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: g.size.width * 0.7, height: g.size.height * 0.7)
                VStack{
                    Text("Game Over")
                        .foregroundStyle(.white)
                        .font(.system(size: 34, weight: .bold))
                        .padding()
                    Button {
                        dismiss()
                        
                    } label: {
                        ZStack{
                            Capsule()
                                .foregroundStyle(.white)
                                .frame(width: g.size.width * 0.6, height: g.size.width * 0.15)
                            Text("Home")
                                .foregroundStyle(.black)
                                .font(.system(size: 24, weight: .bold))
                            
                            
                        }
                        
                    }
                    
                    
                    
                }
                .frame(width: g.size.width * 0.7, height: g.size.height * 0.3)
                
            }
        }

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
    @State var geometry: GeometryProxy
    
    
    var body: some View {
        ZStack {
            Group {
                if flipped {
                    // Лицевая сторона карточки (градиент + изображение)
                    ZStack{
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color(UIColor(hex: "#FDF6E4")))
                            .frame(width: geometry.size.width * 0.065, height: geometry.size.width * 0.065)
                        Image(card.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.065, height: geometry.size.width * 0.065)

                    }
                    .frame(width: geometry.size.width * 0.065, height: geometry.size.width * 0.065)


                } else {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Color(UIColor(hex: "#FDF6E4")))
                        .frame(width: geometry.size.width * 0.065, height: geometry.size.width * 0.065)
                }
            }
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(scale)
        }
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


// В cardsGridView измените расчет размеров:
extension AnyTransition {
    static var flipFromLeft: AnyTransition {
        .modifier(
            active: FlipEffect(angle: 90),
            identity: FlipEffect(angle: 0)
        )
    }
}

struct FlipEffect: ViewModifier {
    var angle: Double

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: (x: 0, y: 1, z: 0)
            )
            .animation(.easeInOut(duration: 0.3), value: angle)
    }
}


extension View {
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
