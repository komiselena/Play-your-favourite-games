import SwiftUI

struct MiniGamesView: View {
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                // Фоновое изображение с размытием
                ZStack {
                    Image(gameViewModel.backgroundImage)
                        .resizable()
                        .blur(radius: 5)
                        .ignoresSafeArea()
                    
                    HStack {
                        Image("inde")
                            .resizable()
                            .scaledToFill()
                            .frame(width: g.size.width * 0.65, height: g.size.height * 0.7)
                            .padding(.trailing, g.size.width * 0.9)
                            .padding(.top, g.size.height * 0.2)
                    }
                }
                .frame(width: g.size.width, height: g.size.height)
                
                // Основное содержимое
                VStack {
                    // Заголовок и кнопка назад
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
                        
                        Text("MINI GAMES")
                            .foregroundStyle(.white)
                            .font(.largeTitle.weight(.bold))
                        
                        Spacer()
                        
                        // Невидимая кнопка для выравнивания
                        Button { dismiss() } label: {
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
                    
                    // Кнопки мини-игр
                    HStack(spacing: -(g.size.width * 0.2)) { // Уменьшил расстояние между колонками
                        // Левая колонка
                        VStack(spacing: g.size.height * 0.1) { // Уменьшил расстояние между кнопками
                            // Угадай число
                            NavigationLink {
                                GuessNumberView(gameData: gameData, gameViewModel: gameViewModel)
                            } label: {
                                ZStack {
                                    Image("image")
                                        .resizable()
                                        .scaledToFit()
                                        .scaleEffect(x: -1, y: 1)
                                        .scaleEffect(2.0)
                                    VStack {
                                        Spacer()
                                        Text("Guess The\nnumber")
                                            .textCase(.uppercase)
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.bold)) // Увеличил шрифт
                                            .padding(.top, g.size.height * 0.1) // Опустил текст
                                    }
                                }
                                .frame(width: g.size.width * 0.55, height: g.size.height * 0.25) // Увеличил размер
                            }
                            
                            // Найди пару
                            NavigationLink {
                                MemoryGameView(gameData: gameData, gameViewModel: gameViewModel)
                            } label: {
                                ZStack {
                                    Image("image")
                                        .resizable()
                                        .scaledToFit()
                                        .scaleEffect(2.0)
                                        .scaleEffect(x: -1, y: 1)
                                    
                                    VStack {
                                        Spacer()
                                        Text("FIND A\nMATCH")
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.bold)) // Увеличил шрифт
                                            .padding(.top, g.size.height * 0.1) // Опустил текст
                                    }
                                }
                                .frame(width: g.size.width * 0.55, height: g.size.height * 0.25)
                            }
                        }
                        
                        // Правая колонка
                        VStack(spacing: g.size.height * 0.1) {
                            // Повтори последовательность
                            NavigationLink {
                                MemorySequnceGameView(gameData: gameData, gameViewModel: gameViewModel)
                            } label: {
                                ZStack {
                                    Image("image")
                                        .resizable()
                                        .scaledToFit()
                                        .scaleEffect(2.0)

                                    VStack {
                                        Spacer()
                                        Text("REPEAT THE\nSEQUENCE")
                                            .textCase(.uppercase)
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.bold)) // Увеличил шрифт
                                            .padding(.top, g.size.height * 0.1) // Опустил текст
                                    }
                                }
                                .frame(width: g.size.width * 0.55, height: g.size.height * 0.25)
                            }
                            
                            // Лабиринт
                            NavigationLink {
                                MazeView(gameData: gameData, gameViewModel: gameViewModel)
                            } label: {
                                ZStack {
                                    Image("image")
                                        .resizable()
                                        .scaledToFit()
                                        .scaleEffect(2.0)

                                    VStack {
                                        Spacer()
                                        Text("FIND A WAY\nTO THE CUP")
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.bold)) // Увеличил шрифт
                                            .padding(.top, g.size.height * 0.1) // Опустил текст
                                    }
                                }
                                .frame(width: g.size.width * 0.55, height: g.size.height * 0.25)
                            }
                        }
                    }
                    .padding(.bottom, g.size.height * 0.05)
                    .frame(width: g.size.width * 0.6, height: g.size.height * 0.9)

                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)
            }
            .frame(width: g.size.width, height: g.size.height)
        }
        .navigationBarBackButtonHidden()
    }
}
