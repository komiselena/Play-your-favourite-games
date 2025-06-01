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
                    .ignoresSafeArea()
                
                
                ZStack{
                    Image("bar")
                        .resizable()
                        .scaledToFill()
                        .frame(width:  g.size.width * 0.8, height: g.size.height * 0.7)


                    if scene.isWon {
                        ZStack{
                            Image(gameViewModel.backgroundImage)
                                .resizable()
                                .ignoresSafeArea()
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
                            
                        }
                    } else{
                        
                        HStack(spacing: 30){
                            Spacer()
                            SpriteView(scene: scene)
                                .frame(width: g.size.width * 0.32, height: g.size.width * 0.32)
                            
                            Spacer()
                            VStack(spacing: 0){
                                // up
                                Button(action: { scene.movePlayer(dx: 0, dy: scene.moveStep) }) {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: g.size.width * 0.08 , height: g.size.width * 0.08)
                                            .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))

                                        Image(systemName: "arrowtriangle.up.fill")
                                            .foregroundStyle(Color(UIColor(hex: "#4B2A28")))
                                            .font(.title.weight(.bold))
                                        
                                        
                                    }
                                }
                                HStack(spacing: 0) {
                                    //left
                                    Button(action: { scene.movePlayer(dx: -scene.moveStep, dy: 0) }) {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 8)
                                                .frame(width: g.size.width * 0.08 , height: g.size.width * 0.08)
                                                .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))

                                            Image(systemName: "arrowtriangle.left.fill")
                                                .foregroundStyle(Color(UIColor(hex: "#4B2A28")))
                                                .font(.title.weight(.bold))
                                            
                                            
                                        }
                                    }
                                    //down
                                    Button(action: {  }) {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 8)
                                                .frame(width: g.size.width * 0.08 , height: g.size.width * 0.08)
                                                .opacity(0.0)

                                            Image(systemName: "arrowtriangle.down.fill")
                                                .foregroundStyle(Color(UIColor(hex: "#4B2A28")))
                                                .font(.title.weight(.bold))
                                            
                                            
                                        }
                                    }
                                    // right
                                    Button(action: { scene.movePlayer(dx: scene.moveStep, dy: 0) }) {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 8)
                                                .frame(width: g.size.width * 0.08 , height: g.size.width * 0.08)
                                                .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))

                                            Image(systemName: "arrowtriangle.right.fill")
                                                .foregroundStyle(Color(UIColor(hex: "#4B2A28")))
                                                .font(.title.weight(.bold))
                                            
                                            
                                        }
                                    }
                                }
                                Button(action: { scene.movePlayer(dx: 0, dy: -scene.moveStep) }) {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: g.size.width * 0.08 , height: g.size.width * 0.08)
                                            .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))

                                        Image(systemName: "arrowtriangle.down.fill")
                                            .foregroundStyle(Color(UIColor(hex: "#4B2A28")))
                                            .font(.title.weight(.bold))
                                        
                                        
                                    }
                                }

                            }
                            
                            Spacer()
                            
                        }
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

                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
                

            }
            .frame(width: g.size.width, height: g.size.height)



        }
        .navigationBarBackButtonHidden()

        
        
    }
}

