//
//  DailyTasksView.swift
//  Play your favorite games
//
//  Created by Mac on 05.06.2025.
//

import SwiftUI

struct DailyTasksView: View {
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showAchButton = true
    
    var body: some View {
        GeometryReader { g in
            ZStack{
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 5)

                VStack{
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
                        
                        Text("DAILY TASKS")
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
                    HStack{
                        VStack(spacing: g.size.width * 0.05){
                            ZStack{
                                
                                Image("image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.3)
                                
                                Text("Win 3 games \n arrow")
                                    .foregroundStyle(.white)
                                    .font(.title3.weight(.bold))
                                    .padding(.top, g.size.height * 0.2)

                            }
                                    ZStack{
                                        Image("buttonBG")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: g.size.width * 0.25, height: g.size.height * 0.18)
                                        HStack{
                                            Image("coin")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.03, height: g.size.width * 0.03)
                                            Text("100")
                                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                .font(.callout.weight(.bold))
                                            
                                        }
                                        .opacity(0.3)
                                        .frame(width: g.size.width * 0.28, height: g.size.height * 0.18)
                                        
                                
                                
                            }
                        }
                        VStack(spacing: g.size.width * 0.05){
                            ZStack{
                                
                                Image("image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.3)
                                
                                Text("Play 5 games \n arow")
                                    .foregroundStyle(.white)
                                    .font(.title3.weight(.bold))
                                    .padding(.top, g.size.height * 0.2)

                            }
                                    ZStack{
                                        Image("buttonBG")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: g.size.width * 0.25, height: g.size.height * 0.18)
                                        HStack{
                                            Image("coin")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.03, height: g.size.width * 0.03)
                                            Text("100")
                                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                .font(.callout.weight(.bold))
                                            
                                        }
                                        .opacity(0.3)

                                        .frame(width: g.size.width * 0.28, height: g.size.height * 0.18)
                                        
                                
                                
                            }
                        }

                        VStack(spacing: g.size.width * 0.05){
                            ZStack{
                                
                                Image("image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.3)
                                
                                Text("Buy one \nskin location")
                                    .foregroundStyle(.white)
                                    .font(.title3.weight(.bold))
                                    .padding(.top, g.size.height * 0.2)

                            }
                                    ZStack{
                                        Image("buttonBG")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: g.size.width * 0.25, height: g.size.height * 0.18)
                                        HStack{
                                            Image("coin")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.03, height: g.size.width * 0.03)
                                            Text("100")
                                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                .font(.callout.weight(.bold))
                                            
                                        }
                                        .opacity(0.3)

                                        .frame(width: g.size.width * 0.28, height: g.size.height * 0.18)
                                        
                                    }
                                
                                
                        }

                        
                    }
                    .frame(width: g.size.width * 0.7, height: g.size.height * 0.9)

                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

            }
            .frame(width: g.size.width, height: g.size.height)

        }
        .navigationBarBackButtonHidden()
    }
}
