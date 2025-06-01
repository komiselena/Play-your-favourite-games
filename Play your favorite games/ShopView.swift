//
//  ShopView.swift
//  Tachi Palace game
//
//  Created by Mac on 20.05.2025.
//

import SwiftUI

struct ShopView: View {
    @State private var bgChosen: Bool = true
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { g in
            ZStack{
                Image(gameViewModel.backgroundImage)
                    .resizable()
                    .ignoresSafeArea()
                VStack{
                    HStack(spacing: 0){
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
                            
                        Spacer()

                        Text("SHOP")
                            .foregroundStyle(.white)
                            .font(.title.weight(.bold))
                        Spacer()

                        ZStack{
                            Rectangle()
                                .foregroundStyle(Color(UIColor(hex: "#4B2A28")))
                                .frame(width: g.size.width * 0.15, height: g.size.height * 0.1)
                                
                            HStack(spacing: 5){
                                Image("coin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.07, height: g.size.width * 0.07)
                                
                                Text("\(gameData.coins)")
                                    .foregroundStyle(.white)
                                    .font(.title3.weight(.bold))
                            }
                            .padding(.trailing, g.size.width * 0.05)
                        }

                        .frame(width: g.size.width * 0.3, height: g.size.height * 0.1)
                        
                    }
                    .padding(.top, g.size.height * 0.1)

                    .frame(height: g.size.height * 0.1)


                    Spacer()
                    VStack{
                        ZStack {
                            // Фон переключателя (темно-синий)
                            Rectangle()
                                .foregroundColor(Color(UIColor(hex: "#003343"))) // Темно-синий цвет
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.06) // Еще более компактный
                                .cornerRadius(12) // Чуть меньше скругление
                            
                            HStack(spacing: 0) {
                                // Кнопка BG
                                Button(action: {
                                    bgChosen = true
                                }) {
                                    ZStack {
                                        // Подсветка выбранной кнопки
                                        if bgChosen {
                                            Rectangle()
                                                .foregroundColor(Color(UIColor(hex: "#E7BB47"))) // Желтый цвет
                                                .frame(width: g.size.width * 0.125, height: g.size.height * 0.06)
                                                .cornerRadius(12, corners: [.topLeft, .bottomLeft])
                                                .padding(.leading, -1)
                                        }
                                        
                                        Text("BG")
                                            .font(.subheadline.weight(.bold)) // Чуть меньший шрифт
                                            .foregroundColor(bgChosen ? Color(UIColor(hex: "#003343")) : .white)
                                            .frame(width: g.size.width * 0.125)
                                    }
                                }
                                
                                // Кнопка SKIN
                                Button(action: {
                                    bgChosen = false
                                }) {
                                    ZStack {
                                        // Подсветка выбранной кнопки
                                        if !bgChosen {
                                            Rectangle()
                                                .foregroundColor(Color(UIColor(hex: "#E7BB47"))) // Желтый цвет
                                                .frame(width: g.size.width * 0.125, height: g.size.height * 0.06)
                                                .cornerRadius(12, corners: [.topRight, .bottomRight])
                                                .padding(.trailing, -1)
                                        }
                                        
                                        Text("SKIN")
                                            .font(.subheadline.weight(.bold)) // Чуть меньший шрифт
                                            .foregroundColor(!bgChosen ? Color(UIColor(hex: "#003343")) : .white)
                                            .frame(width: g.size.width * 0.125)
                                    }
                                }
                            }
                            .frame(width: g.size.width * 0.25, height: g.size.height * 0.06)
                        }
                        .padding(.top, g.size.height * 0.06) // Меньший отступ сверху и снизу

                        if !bgChosen{
                            HStack{
                                VStack(spacing: 15){
                                    Image("skin1")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                        .clipped()
                                        .cornerRadius(15)
                                    
                                    Button {
                                        handleSkinButton(id: 1)
                                    } label: {
                                        ZStack{
                                            Image("buttonBG")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.23, height: g.size.height * 0.16)
                                            
                                            Text(currentSkinButtonImage(for: 1))
                                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                .font(.headline.weight(.bold))
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                                
                                VStack(spacing: 15){
                                    Image("skin2")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                        .clipped()
                                        .cornerRadius(15)
                                    
                                    Button {
                                        handleSkinButton(id: 2)
                                    } label: {
                                        ZStack{
                                            Image("buttonBG")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.23, height: g.size.height * 0.16)
                                            
                                            Text(currentSkinButtonImage(for: 2))
                                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                .font(.headline.weight(.bold))
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                                VStack(spacing: 15){
                                    Image("skin3")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                        .clipped()
                                        .cornerRadius(15)
                                    
                                    Button {
                                        handleSkinButton(id: 3)
                                    } label: {
                                        ZStack{
                                            Image("buttonBG")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.23, height: g.size.height * 0.16)
                                            
                                            Text(currentSkinButtonImage(for: 3))
                                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                .font(.headline.weight(.bold))
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                                VStack(spacing: 15){
                                    Image("skin4")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                        .clipped()
                                        .cornerRadius(15)
                                    
                                    Button {
                                        handleSkinButton(id: 4)
                                    } label: {
                                        ZStack{
                                            Image("buttonBG")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.23, height: g.size.height * 0.16)
                                            
                                            Text(currentSkinButtonImage(for: 4))
                                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                .font(.headline.weight(.bold))
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                                
                            }
                        } else {
                            
                            HStack{
                                VStack(spacing: 15){
                                    Image("shopbg1")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    
                                    Button {
                                        handleBGButton(id: 1)
                                    } label: {
                                        ZStack{
                                            Image("buttonBG")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.23, height: g.size.height * 0.16)
                                            
                                            Text(currentBGButtonImage(for: 1))
                                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                .font(.headline.weight(.bold))
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                                
                                VStack(spacing: 15){
                                    Image("shopbg2")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    
                                    Button {
                                        handleBGButton(id: 2)
                                    } label: {
                                        ZStack{
                                            Image("buttonBG")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.23, height: g.size.height * 0.16)
                                            
                                            Text(currentBGButtonImage(for: 2))
                                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                .font(.headline.weight(.bold))
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                                VStack(spacing: 15){
                                    Image("shopbg3")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    
                                    Button {
                                        handleBGButton(id: 3)
                                    } label: {
                                        ZStack{
                                            Image("buttonBG")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.23, height: g.size.height * 0.16)
                                            
                                            Text(currentBGButtonImage(for: 3))
                                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                .font(.headline.weight(.bold))
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                                VStack(spacing: 15){
                                    Image("shopbg4")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    
                                    Button {
                                        handleBGButton(id: 4)
                                    } label: {
                                        ZStack{
                                            Image("buttonBG")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.23, height: g.size.height * 0.16)
                                            
                                            Text(currentBGButtonImage(for: 4))
                                                .foregroundStyle(Color(UIColor(hex: "#DDB355")))
                                                .font(.headline.weight(.bold))
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                                
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
    
    private func handleSkinButton(id: Int) {
        if gameData.boughtSkinId.contains(id) {
            gameViewModel.skin = "skin\(id)"
            
            gameViewModel.objectWillChange.send()
        } else {
            if gameData.coins >= 100 {
                gameData.coins -= 100
                gameData.boughtSkinId.append(id)
            } else {
                print("Not enough money")
            }
        }
    }

    private func currentSkinButtonImage(for id: Int) -> String {
        if gameData.boughtSkinId.contains(id) && gameViewModel.skin != "skin\(id)" {
            return "CHOOSE"
        } else if gameViewModel.skin == "skin\(id)" {
            return "CHOSEN"
        } else{
            return "BUY 100"
        }
    }
    
    private func handleBGButton(id: Int) {
        if gameData.boughtBackgroundId.contains(id) {
            gameViewModel.backgroundImage = "bg\(id)"
            
            gameViewModel.objectWillChange.send()
        } else {
            if gameData.coins >= 100 {
                gameData.coins -= 100
                gameData.boughtBackgroundId.append(id)
            } else {
                print("Not enough money")
            }
        }
    }

    private func currentBGButtonImage(for id: Int) -> String {
        if gameData.boughtBackgroundId.contains(id) && gameViewModel.backgroundImage != "bg\(id)" {
            return "CHOOSE"
        } else if gameViewModel.backgroundImage == "bg\(id)" {
            return "CHOSEN"
        } else{
            return "BUY 100"
        }
    }

}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
