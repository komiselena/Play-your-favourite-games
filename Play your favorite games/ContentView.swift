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
    
    var isiPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var scene: GameScene {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        scene.gameViewModel = gameViewModel // Передаем viewModel
        return scene
    }

    var body: some View {
        GeometryReader { g in
            ZStack {
                SpriteView(scene: scene)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                    .environmentObject(gameViewModel)

                HStack {
                    ZStack {
                        Image("deck")
                            .resizable()
                            .scaledToFit()
                            .frame(width: isiPad ? g.size.width * 0.25 : g.size.width * 0.3,
                                   height: isiPad ? g.size.height * 0.7 : g.size.height * 0.78)
                        VStack(spacing: isiPad ? g.size.height * 0.02 : g.size.height * 0.03) {
                            Text("ARMY GENERATION")
                                .foregroundStyle(Color(UIColor(hex: "#8FC7F9")))
                                .font(isiPad ? .headline : .caption.weight(.bold))
                            Text("Each area automatically generates soldiers. The more areas you control, the stronger your army")
                                .textCase(.uppercase)
                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                .font(isiPad ? .headline : .caption.weight(.bold))
                        }
                        .frame(width: isiPad ? g.size.width * 0.18 : g.size.width * 0.2,
                               height: isiPad ? g.size.height * 0.45 : g.size.height * 0.5)
                    }
                    .padding(.top, isiPad ? g.size.height * 0.25 : g.size.height * 0.3)
                    .frame(width: isiPad ? g.size.width * 0.18 : g.size.width * 0.2,
                           height: isiPad ? g.size.height * 0.45 : g.size.height * 0.5)
                    .padding(.leading, isiPad ? g.size.width * 0.15 : 0)

                    // Уменьшаем спейсер для iPad
                    Spacer()
                        .frame(width: isiPad ? g.size.width * 0.6 : g.size.width * 0.6,
                               height: isiPad ? g.size.height * 0.6 : g.size.height * 0.7)

                    Image("UiBar")
                        .resizable()
                        .scaledToFit()
                        .frame(width: isiPad ? g.size.width * 0.18 : g.size.width * 0.2,
                               height: isiPad ? g.size.height * 0.6 : g.size.height * 0.7)
                        .padding(.trailing, isiPad ? g.size.width * 0.1 : g.size.width * 0.2)
                }
                .frame(width: g.size.width * 0.95, height: g.size.height * 0.9)
            }
            .overlay(
                Button {
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
                .padding(.top, isiPad ? g.size.height * 0.08 : g.size.height * 0.1)
                .padding(.leading, isiPad ? g.size.height * 0.08 : g.size.height * 0.1)

                , alignment: .topLeading
            )
        }
        .navigationBarBackButtonHidden()
    }
}
