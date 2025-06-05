//
//  AchievementsView.swift
//  Tachi Palace game
//
//  Created by Mac on 20.05.2025.
//

import SwiftUI

struct AchievementsView: View {
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
                        
                        Text("ACHIEVEMENTS")
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

                    HStack(spacing: g.size.width * 0.1){
                        ZStack{
                            RoundedRectangle(cornerRadius: 18)
                                .frame(width: g.size.width * 0.26, height: g.size.height * 0.68)
                                .foregroundStyle(Color(UIColor(hex: "#746931")))
                            VStack(spacing: g.size.height * 0.03){
                                Text("THE FIRST STEP")
                                    .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))
                                    .font(.caption.weight(.bold))
                                Text("CAPTURE \nTHE FIRST \nTERRITORY")
                                    .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                    .font(.title3.weight(.bold))
                                Button {
                                    gameData.coins += 10
                                    showAchButton = false
                                } label: {
                                    if showAchButton {
                                        ZStack{
                                            Image("buttonBG")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.18)
                                            HStack{
                                                Text("CLAIM")
                                                    .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                    .font(.callout.weight(.bold))
                                                Image("coin")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width * 0.03, height: g.size.width * 0.03)
                                                Text("10")
                                                    .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                    .font(.callout.weight(.bold))
                                                
                                            }
                                            .frame(width: g.size.width * 0.28, height: g.size.height * 0.18)

                                        }
                                    }

                                }
                                
                            }
                            .frame(width: g.size.width * 0.2, height: g.size.height * 0.5)

                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 18)
                                .frame(width: g.size.width * 0.26, height: g.size.height * 0.68)
                                .foregroundStyle(Color(UIColor(hex: "#746931")))
                            VStack(spacing: g.size.height * 0.03){
                                Text("THE FIRST VICTORy")
                                    .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))
                                    .font(.caption.weight(.bold))
                                    .opacity(0.5)

                                Text("WIN THE \nFIRST MATCH")
                                    .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                    .font(.title3.weight(.bold))
                                    .opacity(0.5)
                                Spacer()
                                    .frame(width: g.size.width * 0.2, height: g.size.height * 0.15)

                                
                            }
                            .frame(width: g.size.width * 0.25, height: g.size.height * 0.5)

                        }
                        ZStack{
                            RoundedRectangle(cornerRadius: 18)
                                .frame(width: g.size.width * 0.26, height: g.size.height * 0.68)
                                .foregroundStyle(Color(UIColor(hex: "#746931")))
                            VStack(spacing: g.size.height * 0.03){
                                Text("COMBO CAPTURE")
                                    .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))
                                    .font(.caption.weight(.bold))
                                    .opacity(0.5)

                                Text("CAPTURE 3 \nZONES IN \nONE TURN")
                                    .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                    .font(.title3.weight(.bold))
                                    .opacity(0.5)

                                Spacer()
                                    .frame(width: g.size.width * 0.2, height: g.size.height * 0.09)

                                
                            }
                            .frame(width: g.size.width * 0.2, height: g.size.height * 0.5)

                        }

                    }
                    .padding(.top, g.size.height * 0.15)
                    .frame(width: g.size.width * 0.7, height: g.size.height * 0.9)

                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

            }
            .frame(width: g.size.width, height: g.size.height)

        }
        .navigationBarBackButtonHidden()
    }
}
