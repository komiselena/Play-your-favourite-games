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
            NavigationStack {
                GeometryReader { g in
                    ZStack(alignment: .bottom) {
                        ZStack{
                            Image(gameViewModel.backgroundImage)
                                .resizable()
                                .blur(radius: 5)

                                .ignoresSafeArea()
                            HStack{
                                Image("inde")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.65, height: g.size.height * 0.7)
                                    .padding(.leading, g.size.width * 0.5)
                                    .padding(.top, g.size.height * 0.2)

                            }
                            HStack {
                                Image("inde")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.65, height: g.size.height * 0.7)
                                    .padding(.trailing, g.size.width )
                                    .padding(.top, g.size.height * 0.2)
                            }

                        }
                        .frame(width: g.size.width, height: g.size.height)

                        HStack{
                            VStack{
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
                                Spacer()

                                HStack(spacing: 0){
                                    VStack{
                                        NavigationLink {
                                            MiniGamesView(gameData: gameData, gameViewModel: gameViewModel)
                                        } label: {
                                            ZStack{
                                                Image("card")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                                Image(systemName: "gamecontroller.fill")
                                                    .foregroundStyle(Color(UIColor(hex: "#CCB35A")))
                                                    .font(.title)
                                            }
                                        }

                                        NavigationLink {
                                            ShopView(gameData: gameData, gameViewModel: gameViewModel)
                                        } label: {
                                            ZStack{
                                                Image("card")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                                Image(systemName: "cart.fill")
                                                    .foregroundStyle(Color(UIColor(hex: "#CCB35A")))
                                                    .font(.title)
                                            }
                                        }

                                        
                                        
                                    }
                                    
                                    
                                    NavigationLink {
                                        LevelView(gameData: gameData, gameViewModel: gameViewModel)
                                    } label: {
                                        ZStack{
                                            Image("image")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.45 : 0.48), height: g.size.height * (UIDevice.current.userInterfaceIdiom == .pad ? 0.45 : 0.55))

                                                Text("play")
                                                    .textCase(.uppercase)
                                                    .foregroundStyle(.white)
                                                    .font(.largeTitle.weight(.bold))
                                                    .padding(.top, g.size.height * 0.2)

                                        }

                                    }
                                    
                                    VStack{
                                        NavigationLink {
                                            AchievementsView(gameData: gameData, gameViewModel: gameViewModel)
                                        } label: {
                                            ZStack{
                                                Image("card")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                                Image(systemName: "trophy.fill")
                                                    .foregroundStyle(Color(UIColor(hex: "#CCB35A")))
                                                    .font(.title)
                                            }
                                        }
                                        NavigationLink {
                                            DailyTasksView(gameData: gameData, gameViewModel: gameViewModel)
                                        } label: {
                                            ZStack{
                                                Image("card")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                                Image(systemName: "calendar")
                                                    .foregroundStyle(Color(UIColor(hex: "#CCB35A")))
                                                    .font(.title)
                                            }
                                        }

                                    }
                                    
                                }
                                .frame(width: g.size.width * 0.4)

                            }
                            .frame(width: g.size.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.5 : 0.6), height: g.size.height * 0.9)


                        }

                    }
                    .overlay(
                        NavigationLink {
                            SettingsView(gameData: gameData, gameViewModel: gameViewModel)
                        } label: {
                            ZStack{
                                Image("card")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                Image(systemName: "gear")
                                    .foregroundStyle(Color(UIColor(hex: "#CCB35A")))
                                    .font(.title)
                            }

                            
                        }
                            .padding(.top, g.size.height * 0.1)
                            .padding(.trailing, g.size.height * 0.1)


                        ,alignment: .topTrailing
                    )
                    
                    .frame(width: g.size.width, height: g.size.height)

                }
                .navigationBarBackButtonHidden()


            }

    }
    
}

#Preview {
    MainMenuView()
}
