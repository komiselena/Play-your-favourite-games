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
    @Environment(\.dismiss) var dismiss
    
    var scene: GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        return scene
    }
    
    var body: some View {
        GeometryReader{ g in
            ZStack{
                SpriteView(scene: scene)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
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
                    .padding(.bottom, g.size.height * 0.1)

                ,alignment: .topLeading
            )

        }
        .navigationBarBackButtonHidden()
    }
}
