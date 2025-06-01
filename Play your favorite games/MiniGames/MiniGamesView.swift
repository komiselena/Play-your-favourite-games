//
//  MiniGamesView.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import SwiftUI

struct MiniGamesView: View {
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { g in
            ZStack{
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                    ZStack{
                        Image("bar")
                            .resizable()
                            .scaledToFill()
                            .frame(width:  g.size.width * 0.8, height: g.size.height * 0.7)
                        HStack{
                            VStack{
                                Text("MINI GAMES")
                                    .foregroundStyle(.white)
                                    .font(.title.weight(.bold))
                                HStack(spacing: g.size.width * 0.1){
                                    VStack{
                                        NavigationLink {
                                            GuessNumberView(gameData: gameData, gameViewModel: gameViewModel)
                                        } label: {
                                            ZStack{
                                                Image("buttonBG")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width *  0.28, height: g.size.height * 0.28)
                                                    Text("Guess The \nnumber")
                                                        .textCase(.uppercase)
                                                        .foregroundStyle(.white)
                                                        .font(.headline.weight(.bold))

                                            }
                                            .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.2 : 0.25), height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.18 : 0.21))

                                        }

                                        NavigationLink {
                                            MemoryGameView(gameData: gameData, gameViewModel: gameViewModel)
                                        } label: {
                                            ZStack{
                                                Image("buttonBG")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width *  0.28, height: g.size.height * 0.28)
                                                    Text("MATCH THE \n CARDS")
                                                        .foregroundStyle(.white)
                                                        .font(.headline.weight(.bold))

                                            }
                                            .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.2 : 0.25), height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.18 : 0.21))

                                        }
                                        
                                    }
                                    VStack{
                                        NavigationLink {
                                            MemorySequnceGameView(gameData: gameData, gameViewModel: gameViewModel)
                                        } label: {
                                            ZStack{
                                                Image("buttonBG")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width *  0.28, height: g.size.height * 0.28)
                                                    Text("Simon says")
                                                        .textCase(.uppercase)
                                                        .foregroundStyle(.white)
                                                        .font(.headline.weight(.bold))

                                            }
                                            .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.2 : 0.25), height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.18 : 0.21))

                                        }

                                        NavigationLink {
                                            MazeView(gameData: gameData, gameViewModel: gameViewModel)
                                        } label: {
                                            ZStack{
                                                Image("buttonBG")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width *  0.28, height: g.size.height * 0.28)
                                                    Text("MAZE \n CHALLENGE")
                                                        .foregroundStyle(.white)
                                                        .font(.headline.weight(.bold))

                                            }
                                            .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.2 : 0.25), height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.18 : 0.21))

                                        }
                                        
                                    }
                                }

                            }

                            
                        }
                        .frame(width:  g.size.width * 0.7, height: g.size.height * 0.6)
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

                    .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

            }
            .frame(width: g.size.width, height: g.size.height)

        }
        .navigationBarBackButtonHidden()
    }
}
