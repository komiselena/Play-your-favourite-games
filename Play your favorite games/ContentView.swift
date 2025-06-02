//
//  ContentView.swift
//  Play your favorite games
//
//  Created by Mac on 30.05.2025.
//


import SwiftUI
import SpriteKit

// MARK: - SwiftUI Integration
struct ContentView: View {
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var scene: GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        scene.gameViewModel = gameViewModel // Передаем viewModel
        return scene
    }

    var body: some View {
        GeometryReader{ g in
            ZStack{
                SpriteView(scene: scene)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                    .environmentObject(gameViewModel)

                HStack{
                    ZStack{
                        
                        Image("deck")
                            .resizable()
                            .scaledToFit()
                            .frame(width: g.size.width * 0.3, height: g.size.height * 0.78)
                        VStack(spacing: g.size.height * 0.03){
                            Text("ARMY GENERATION")
                                .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))
                                .font(.caption.weight(.bold))
                            Text("Each area automatically generates soldiers. The more areas you control, the stronger your army")
                                .textCase(.uppercase)
                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                .font(.caption.weight(.bold))
                            
                        }
                        .frame(width: g.size.width * 0.2, height: g.size.height * 0.5)

                    }
                    .padding(.top, g.size.height * 0.3)
                    .frame(width: g.size.width * 0.2, height: g.size.height * 0.5)

                    
                    Spacer()
                        .frame(width: g.size.width * 0.6, height: g.size.height * 0.7)

                    Image("UiBar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: g.size.width * 0.2, height: g.size.height * 0.7)
                        .padding(.trailing, g.size.width * 0.2)
                    
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
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
                    .padding(.top, g.size.height * 0.1)

                ,alignment: .topLeading
            )

        }
        .navigationBarBackButtonHidden()
    }
}
