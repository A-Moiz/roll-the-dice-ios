// EndScreenView.swift
// Roll the Dice
//
// Created by Assistant

import SwiftUI
import Lottie

struct EndScreenView: View {
    // MARK: Properties
    let gameScore: GameScore
    var onDismiss: (() -> Void)?
    @ObservedObject var viewModel: GameViewModel
    
    init(gameScore: GameScore, onDismiss: (() -> Void)? = nil, viewModel: GameViewModel) {
        self.gameScore = gameScore
        self.onDismiss = onDismiss
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Image("WitchingHour")
                    .resizable()
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    AnimationView(gameScore: gameScore)
                    
                    Text(titleText)
                        .font(.system(size: 44, weight: .heavy, design: .rounded))
                        .foregroundStyle(gameScore.result == "Win" ? .green : (gameScore.result == "Lose" ? .red : .yellow))
                        .multilineTextAlignment(.center)

                    GameDetails(gameScore: gameScore)

                    Spacer()

                    ActionButtonsView(onDismiss: onDismiss, viewModel: viewModel)
                }
                .padding()
            }
            .navigationTitle("Game Over")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var titleText: String {
        switch gameScore.result {
        case "Win": return "You Win!"
        case "Lose": return "You Lose"
        default: return "It's a Draw"
        }
    }
}

struct AnimationView: View {
    // MARK: Properties
    let gameScore: GameScore
    
    var body: some View {
        VStack {
            if gameScore.result == "Lose" {
                LottieView(animation: .named("lose"))
                    .playing(loopMode: .loop)
            } else {
                LottieView(animation: .named("win"))
                    .playing(loopMode: .loop)
            }
        }
    }
}

struct GameDetails: View {
    // MARK: Properties
    let gameScore: GameScore
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Target: \(gameScore.targetScore)")
                .font(.title3)
                .foregroundStyle(.white)
            Text("Your Score: \(gameScore.playerScore)")
                .font(.title2)
                .foregroundStyle(.white)
            Text("Computer Score: \(gameScore.computerScore)")
                .font(.title2)
                .foregroundStyle(.white)
        }
    }
}

struct ActionButtonsView: View {
    // MARK: Properties
    var onDismiss: (() -> Void)?
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            Button {
                viewModel.reset()
            } label: {
                ButtonView(buttonTxt: "Play Again")
            }
            
            Button {
                onDismiss?()
            } label: {
                ButtonView(buttonTxt: "Back to Home")
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    EndScreenView(gameScore: GameScore(id: UUID().uuidString, date: Date(), targetScore: 100, playerScore: 120, computerScore: 90), viewModel: GameViewModel())
}
