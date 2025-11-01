//
//  ContentView.swift
//  Roll the Dice
//
//  Created by Abdul Moiz on 15/09/2025.
//

import SwiftUI
import Lottie

struct HomeView: View {
    // MARK: Properties
    @StateObject private var viewModel = GameViewModel()
    @State private var showGameHistory: Bool = false
    @State private var showResetAlert: Bool = false
    @State private var isShowingRules: Bool = false
    @State private var startNewGame: Bool = false
    @State private var showGameFullScreen: Bool = false
    @State private var selectedTargetScore: Int = 0
    
    // MARK: Button Grid
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var buttons: [(buttonTxt: String, action: () -> Void)] {
        [
            ("New Game", newGame),
            ("Rules", rules),
            ("Reset Scores", resetScores),
            ("Game History", gameHistory)
        ]
    }
    
    var body: some View {
        ZStack {
            Image("WitchingHour")
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 40) {
                // MARK: Header with Lottie animation
                VStack(spacing: 20) {
                    LottieView(animation: .named("dice-roll"))
                        .playing(loopMode: .loop)
                        .frame(height: 300)
                        .shadow(radius: 10)
                    
                    Text("Roll the Dice")
                        .font(.system(size: 60,
                                      weight: .heavy,
                                      design: .rounded))
                        .foregroundStyle(Color("BrightYellow"))
                        .shadow(color: .black.opacity(0.4),
                                radius: 5, x: 2, y: 2)
                }
                .frame(maxHeight: 350)
                
                Spacer()
                
                // MARK: Button Grid
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<buttons.count, id: \.self) { index in
                        let button = buttons[index]
                        Button(action: button.action) {
                            ButtonView(buttonTxt: button.buttonTxt)
                                .shadow(color: .black.opacity(0.25), radius: 5, x: 2, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.vertical)
        }
        // MARK: Sheets and FullScreenCover
        .sheet(isPresented: $isShowingRules) {
            RulesView()
                .presentationDetents([.large])
                .background(
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(Color("MainBG"))
                        .ignoresSafeArea()
                )
        }
        .sheet(isPresented: $startNewGame) {
            TargetSelectView(onStartGame: { score in
                selectedTargetScore = score
                startNewGame = false
                showGameFullScreen = true
            })
            .presentationDetents([.large])
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color("MainBG"))
                    .ignoresSafeArea()
            )
        }
        .fullScreenCover(isPresented: $showGameFullScreen) {
            GameView(targetScore: $selectedTargetScore, viewModel: viewModel)
        }
        .sheet(isPresented: $showGameHistory) {
            GameHistory(viewModel: viewModel)
        }
        // MARK: Reset Alert
        .alert("Reset Scores", isPresented: $showResetAlert) {
            Button("Reset Scores", role: .destructive) {
                viewModel.gameHistory.removeAll()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Are you sure you want to reset all game scores?")
        }
    }
    
    // MARK: Actions
    private func newGame() {
        viewModel.reset()
        startNewGame = true
    }
    
    private func rules() {
        isShowingRules = true
    }
    
    private func resetScores() {
        showResetAlert = true
    }
    
    private func gameHistory() {
        showGameHistory = true
    }
}

#Preview {
    HomeView()
}
