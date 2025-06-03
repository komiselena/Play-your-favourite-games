//
//  MainMenuView.swift
//  San Pablo big games
//
//  Created by Mac on 21.05.2025.
//


import SwiftUI

struct MainMenuView: View {
    @StateObject private var gameData = GameData()
    @StateObject private var gameViewModel = GameViewModel()
    @State private var selectedTab: Int = 0
    
    var isiPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                GeometryReader { g in
                    ZStack(alignment: .bottom) {
                        ZStack{
                            Image(gameViewModel.backgroundImage)
                                .resizable()
                            
                                .ignoresSafeArea()
                            HStack{
                                Image("inde")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.4, height: g.size.height * 0.7)
                                    .padding(.leading, g.size.width * 0.7)
                                    .padding(.top, isiPad ? g.size.height * 0.4 : g.size.height * 0.2)
                                
                            }
                        }
                        .frame(width: g.size.width, height: g.size.height)

                        HStack{
                            VStack{
                                Image("icon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.12, height: g.size.width * 0.12)
                                VStack{
                                    
                                    NavigationLink {
//                                        GameContainerView()
//                                        ContentView(gameViewModel: gameViewModel)
                                        LevelView(gameData: gameData, gameViewModel: gameViewModel)
                                    } label: {
                                        ZStack{
                                            Image("buttonBG")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.2 : 0.25), height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.18 : 0.21))
                                                Text("PLAY")
                                                    .textCase(.uppercase)
                                                    .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                    .font(.title.weight(.bold))

                                        }
                                        .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.2 : 0.25), height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.18 : 0.21))

                                    }
                                    
                                    HStack(spacing: g.size.width * 0.1){
                                        NavigationLink {
                                            AchievementsView(gameData: gameData, gameViewModel: gameViewModel)
                                        } label: {
                                            ZStack{
                                                Image("buttonBG")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.2 : 0.25), height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.18 : 0.21))
                                                    Text("ACHIEVES")
                                                        .textCase(.uppercase)
                                                        .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                        .font(.title.weight(.bold))

                                            }
                                            .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.2 : 0.25), height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.18 : 0.21))

                                        }
                                        NavigationLink {
                                            ShopView(gameData: gameData, gameViewModel: gameViewModel)
                                        } label: {
                                            ZStack{
                                                Image("buttonBG")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.2 : 0.25), height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.18 : 0.21))
                                                    Text("SHOP")
                                                        .textCase(.uppercase)
                                                        .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                        .font(.title.weight(.bold))

                                            }
                                            .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.2 : 0.25), height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.18 : 0.21))

                                        }
                                    }
                                }
                                

                            }
                            .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.5 : 0.6), height: g.size.height * 0.9)


                        }

                    }
                    .overlay(
                        NavigationLink {
                            MiniGamesView(gameData: gameData, gameViewModel: gameViewModel)
                        } label: {
                            Image("miniGames")
                                .resizable()
                                .scaledToFit()
                                .frame(width: g.size.width * 0.12, height: g.size.width * 0.12)

                        }
                            .padding(.leading, g.size.height * 0.1)

                        ,alignment: .bottomLeading

                    )
                    .overlay(
                        NavigationLink {
                            SettingsView(gameData: gameData, gameViewModel: gameViewModel)
                        } label: {
                            Image(systemName: "gear")
                                .foregroundStyle(.white)
                                .font(.title)
                                .padding(6)
                                .background(
                                    Circle()
                                        .foregroundStyle(Color(UIColor(hex: "#4B2A28")))
                                    
                                )
                            
                            
                        }
                            .padding(.top, g.size.height * 0.1)
                            .padding(.trailing, g.size.height * 0.1)


                        ,alignment: .topTrailing
                    )
                    .overlay(
                        ZStack{
                            Rectangle()
                                .foregroundStyle(Color(UIColor(hex: "#4B2A28")))
                                .frame(width: g.size.width * 0.15, height: g.size.height * 0.1)
                                
                            HStack(spacing: 5){
                                Image("coin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.07, height: g.size.width * 0.07)
                                
                                Text("\(gameData.coins)")
                                    .foregroundStyle(.white)
                                    .font(.title3.weight(.bold))
                            }
                            .padding(.trailing, isiPad ? g.size.width * 0.1 : g.size.width * 0.05)
                        }
                            .padding(.top, g.size.height * 0.1)

                            .frame(width: g.size.width * 0.3, height: g.size.height * 0.1)
                        
                        ,alignment: .topLeading
                        
                    )
                    //                    .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
                    
                    .frame(width: g.size.width, height: g.size.height)

                }
                .navigationBarBackButtonHidden()


            }


            
        } else {
            NavigationView {
                ZStack(alignment: .bottom) {
                    
                }
            }
        }
    }
    
}

#Preview {
    MainMenuView()
}
