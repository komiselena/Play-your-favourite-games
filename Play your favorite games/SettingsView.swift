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
    
    var body: some View {
        GeometryReader { g in
            ZStack{
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                VStack{
                    // Игровое поле
                        ZStack{
                            Image("bar")
                                .resizable()
                                .scaledToFill()
                                .frame(width:  g.size.width * 0.8, height: g.size.height * 0.7)
                            
                            VStack{
                                
                                Text("SETTINGS")
                                    .foregroundStyle(.white)
                                    .font(.title.weight(.bold))

                                Spacer()
                                
                                HStack(spacing: g.size.width * 0.1){
                                    VStack(spacing: g.size.height * 0.01){
                                        Text("MUSIC")
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.bold))
                                        Image(systemName: "music.note")
                                            .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                            .font(.title)
                                        
                                        //toggle
                                        toggleSwitch(isOn: $musicManager.musicOn)
                                            .frame(width: g.size.width * 0.13, height: g.size.height * 0.09)

                                    }
                                    VStack(spacing: g.size.height * 0.01){
                                        Text("SOUND")
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.bold))
                                        Image(systemName: "volume.2.fill")
                                            .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                            .font(.title)
                                        
                                        //toggle
                                        toggleSwitch(isOn: $musicManager.soundsOn)
                                            .frame(width: g.size.width * 0.13, height: g.size.height * 0.09)

                                        
                                    }
                                    VStack(spacing: g.size.height * 0.01){
                                        Text("VIBRO")
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.bold))
                                        Image(systemName: "lightspectrum.horizontal")
                                            .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                            .font(.title)
                                        
                                        //toggle
                                        toggleSwitch(isOn: $musicManager.vibroOn)
                                            .frame(width: g.size.width * 0.13, height: g.size.height * 0.09)

                                        
                                    }

                                    
                                }
                                
                                VStack(spacing: g.size.height * 0.01){
                                    Text("RE-TRAINING")
                                        .foregroundStyle(.white)
                                        .font(.headline.weight(.bold))
                                    
                                    //toggle
                                    toggleSwitch(isOn: .constant(false))
                                        .frame(width: g.size.width * 0.13, height: g.size.height * 0.09)

                                }
                                
                                
                            }
                            .frame(width:  g.size.width * 0.7, height: g.size.height * 0.6)

                            
                            
                        }
                        .frame(width: g.size.width * 0.9, height: g.size.height * 0.6)

                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
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
            .frame(width: g.size.width , height: g.size.height )


        }

        .navigationBarBackButtonHidden()
        
        
    }
    private func toggleSwitch(isOn: Binding<Bool>) -> some View {
        ZStack {
            // Фон переключателя (темно-синий)
            Rectangle()
                .foregroundColor(Color(UIColor(hex: "#003343")))
                .cornerRadius(10)
            
            HStack(spacing: 0) {
                // Кнопка OFF
                Button(action: {
                    isOn.wrappedValue = false
                }) {
                    ZStack {
                        if !isOn.wrappedValue {
                            Rectangle()
                                .foregroundColor(Color(UIColor(hex: "#E7BB47")))
                                .cornerRadius(10)
                                .padding(.leading, -1)
                        }
                        
                        Text("OFF")
                            .font(.system(size: 12).weight(.bold))
                            .foregroundColor(!isOn.wrappedValue ? Color(UIColor(hex: "#003343")) : .white)
                            .opacity(0.0)
                            .frame(width: UIScreen.main.bounds.width * 0.065) // Половина ширины переключателя
                    }
                }
                
                // Кнопка ON
                Button(action: {
                    isOn.wrappedValue = true
                }) {
                    ZStack {
                        if isOn.wrappedValue {
                            Rectangle()
                                .foregroundColor(Color(UIColor(hex: "#E7BB47")))
                                .cornerRadius(10)
                                .padding(.trailing, -1)
                        }
                        
                        Text("ON")
                            .font(.system(size: 12).weight(.bold))
                            .foregroundColor(isOn.wrappedValue ? Color(UIColor(hex: "#003343")) : .white)
                            .opacity(0.0)

                            .frame(width: UIScreen.main.bounds.width * 0.065) // Половина ширины переключателя
                    }
                }
            }
        }
    }

    
}


