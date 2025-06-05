//
//  MazeView.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import SwiftUI
import SpriteKit

struct MazeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scene: MazeGameScene

    @ObservedObject var gameData: GameData
    @State private var timeLeft = 90
    @State private var timer: Timer?
    @State private var showWin = false
    @ObservedObject var gameViewModel: GameViewModel

    init(gameData: GameData, gameViewModel: GameViewModel) {
        self.gameData = gameData
        self.gameViewModel = gameViewModel
        let scene = MazeGameScene(size: CGSize(width: 196, height: 196))
        scene.onGameWon = {
            scene.isWon = true
        }
        self._scene = StateObject(wrappedValue: scene)
    }

    var body: some View {
        GeometryReader { g in
            ZStack{
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .blur(radius: 5)
                    .ignoresSafeArea()
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
                        
                        Text("FIND A WAY TO THE CUP")
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
                    
                    ZStack{
                        if scene.isWon {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundStyle(.black)
                                        .opacity(0.3)
                                        .frame(width: g.size.width * 0.7, height: g.size.height * 0.7)
                                    
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
                                                Circle()
                                                    .foregroundStyle(.red)
                                                    .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                                Image(systemName: "house")
                                                    .font(.title)
                                                    .foregroundStyle(.white)
                                                
                                            }
                                            
                                        }
                                    }
                                    .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)
                                }
                                
                        } else{
                            
                            HStack(spacing: 30){
                                ZStack{
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color(UIColor(hex: "#746931")))
                                        .frame(width: g.size.width * 0.6, height: g.size.height * 0.6)
                                    SpriteView(scene: scene)
                                        .frame(width: g.size.width * 0.28, height: g.size.width * 0.28)
                                    
                                }
                                
                                Spacer()
                                VStack(spacing: 0){
                                    // up
                                    Button(action: { scene.movePlayer(dx: 0, dy: scene.moveStep) }) {
                                            Image("arrow")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.08 , height: g.size.width * 0.08)
                                            
                                    }
                                    HStack(spacing: 0) {
                                        //left
                                        Button(action: { scene.movePlayer(dx: -scene.moveStep, dy: 0) }) {
                                            Image("arrow")
                                                .resizable()
                                                .scaledToFit()
                                                .rotationEffect(Angle(degrees: -90))
                                                .frame(width: g.size.width * 0.08 , height: g.size.width * 0.08)
                                        }
                                        //down opacity 0.0
                                        Button(action: {  }) {
                                            Image("arrow")
                                                .resizable()
                                                .scaledToFit()
                                                .rotationEffect(Angle(degrees: 180))
                                                .frame(width: g.size.width * 0.08 , height: g.size.width * 0.08)
                                                .opacity(0.0)
                                        }
                                        // right
                                        Button(action: { scene.movePlayer(dx: scene.moveStep, dy: 0) }) {
                                            Image("arrow")
                                                .resizable()
                                                .scaledToFit()
                                                .rotationEffect(Angle(degrees: 90))
                                                .frame(width: g.size.width * 0.08 , height: g.size.width * 0.08)
                                        }
                                    }
                                    //down
                                    Button(action: { scene.movePlayer(dx: 0, dy: -scene.moveStep) }) {
                                        Image("arrow")
                                            .resizable()
                                            .scaledToFit()
                                            .rotationEffect(Angle(degrees: 180))
                                            .frame(width: g.size.width * 0.08 , height: g.size.width * 0.08)
                                    }
                                    
                                }
                                
                                Spacer()
                                
                            }
                        }
                        
                    }
                }

                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
                

            }
            .frame(width: g.size.width, height: g.size.height)



        }
        .navigationBarBackButtonHidden()

        
        
    }
}

