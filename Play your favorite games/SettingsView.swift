//
//  SettingsView.swift
//  Tachi Palace game
//
//  Created by Mac on 20.05.2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @ObservedObject var musicManager = MusicManager.shared
    @Environment(\.dismiss) var dismiss
    
    var isiPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    var body: some View {
        GeometryReader { g in
            ZStack{
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                    .blur(radius: 5)

                VStack{
                    // Игровое поле
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
                            
                            Text("SETTINGS")
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
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color(UIColor(hex: "#746931")))
                                .frame(width: g.size.width * 0.75, height: g.size.height * 0.7)
                            VStack{
                                HStack(spacing: g.size.width * 0.1){
                                    VStack(spacing: g.size.height * 0.01){
                                        Text("MUSIC")
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.bold))
                                        Image(systemName: "music.note")
                                            .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                            .font(.title)
                                        
                                        // Изменено: теперь переключатель вызывает toggleMusic()
                                        toggleSwitch(isOn: Binding(
                                            get: { musicManager.musicOn },
                                            set: { _ in musicManager.toggleMusic() }
                                        ))
                                        .frame(width: g.size.width * 0.13, height: g.size.height * 0.09)
                                    }
                                    VStack(spacing: g.size.height * 0.01){
                                        Text("SOUND")
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.bold))
                                        Image(systemName: "volume.2.fill")
                                            .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                            .font(.title)
                                        
                                        // Изменено: теперь переключатель вызывает toggleSounds()
                                        toggleSwitch(isOn: Binding(
                                            get: { musicManager.soundsOn },
                                            set: { _ in musicManager.toggleSounds() }
                                        ))
                                        .frame(width: g.size.width * 0.13, height: g.size.height * 0.09)
                                    }
                                    VStack(spacing: g.size.height * 0.01){
                                        Text("VIBRO")
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.bold))
                                        Image(systemName: "lightspectrum.horizontal")
                                            .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                            .font(.title)
                                        
                                        toggleSwitch(isOn: $musicManager.vibroOn)
                                            .frame(width: g.size.width * 0.13, height: g.size.height * 0.09)
                                    }
                                }
                                .padding(.bottom, isiPad ? g.size.height * 0.1 : 0)
                                
                                VStack(spacing: g.size.height * 0.01){
                                    Text("RE-TRAINING")
                                        .foregroundStyle(.white)
                                        .font(.headline.weight(.bold))
                                    
                                    toggleSwitch(isOn: .constant(false))
                                        .frame(width: g.size.width * 0.13, height: g.size.height * 0.09)
                                }
                                .padding(.bottom, isiPad ? g.size.height * 0.1 : 0)
                            }
                        }
                        .frame(width:  g.size.width * 0.7, height: g.size.height * 0.6)

                    }
                    .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
            }
            .frame(width: g.size.width , height: g.size.height )
        }
        .navigationBarBackButtonHidden()
    }
    
    private func toggleSwitch(isOn: Binding<Bool>) -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(UIColor(hex: "#003343")))
                .cornerRadius(10)
            
            HStack(spacing: 0) {
                Button(action: {
                    isOn.wrappedValue = false
                }) {
                    ZStack {
                        if !isOn.wrappedValue {
                            Rectangle()
                                .foregroundColor(Color(UIColor(hex: "#75FBFD")))
                                .cornerRadius(10)
                                .padding(.leading, -1)
                        }
                        
                        Text("OFF")
                            .font(.system(size: 12).weight(.bold))
                            .foregroundColor(!isOn.wrappedValue ? Color(UIColor(hex: "#DA4323")) : .white)
                            .opacity(0.0)
                            .frame(width: UIScreen.main.bounds.width * 0.065)
                    }
                }
                
                Button(action: {
                    isOn.wrappedValue = true
                }) {
                    ZStack {
                        if isOn.wrappedValue {
                            Rectangle()
                                .foregroundColor(Color(UIColor(hex: "#75FBFD")))
                                .cornerRadius(10)
                                .padding(.trailing, -1)
                        }
                        
                        Text("ON")
                            .font(.system(size: 12).weight(.bold))
                            .foregroundColor(isOn.wrappedValue ? Color(UIColor(hex: "#003343")) : .white)
                            .opacity(0.0)
                            .frame(width: UIScreen.main.bounds.width * 0.065)
                    }
                }
            }
        }
    }
}
