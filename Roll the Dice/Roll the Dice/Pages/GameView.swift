//
//  GameView.swift
//  Roll the Dice
//
//  Created by Abdul Moiz on 25/09/2025.
//

import SwiftUI

struct GameView: View {
    // MARK: Properties
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""
    @State private var quitGame: Bool = false
    @Binding var targetScore: Int
    @State private var isRolling = false
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("Firewatch")
                    .resizable()
                    .ignoresSafeArea()
                
                VStack {
                    ComputerView(viewModel: viewModel)
                    
                    Spacer()
                    
                    GameButtons(viewModel: viewModel)
                    
                    Spacer()
                    
                    UserView(viewModel: viewModel)
                }
                .padding()
            }
            .navigationTitle("Roll the Dice!")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        alertTitle = "Quit Game"
                        alertMessage = "Are you sure you want to quit the game?"
                        showAlert = true
                    } label: {
                        Text("Quit")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text("Target: \(targetScore)")
                }
            }
            .onAppear { viewModel.evaluateEndCondition(target: targetScore) }
            .alert(isPresented: $showAlert) { quitAlert }
            .fullScreenCover(isPresented: $quitGame) { HomeView() }
            .fullScreenCover(isPresented: $viewModel.showEnd) { endScreenView }
            .onChange(of: viewModel.didUserJustScore) { _, didScore in
                if didScore {
                    Task { await viewModel.playComputerTurn() }
                    viewModel.didUserJustScore = false
                }
            }
            .onChange(of: viewModel.userScore) { _, _ in
                viewModel.evaluateEndCondition(target: targetScore)
            }
            .onChange(of: viewModel.computerScore) { _, _ in
                viewModel.evaluateEndCondition(target: targetScore)
            }
            .onChange(of: viewModel.isRolling) { _, isRolling in
                if !isRolling { viewModel.evaluateEndCondition(target: targetScore) }
            }
        }
    }
    
    private var quitAlert: Alert {
        Alert(
            title: Text(alertTitle),
            message: Text(alertMessage),
            primaryButton: .destructive(Text("Quit"), action: { quitGame = true }),
            secondaryButton: .cancel()
        )
    }
    
    @ViewBuilder
    private var endScreenView: some View {
        if let score = viewModel.lastGameScore {
            EndScreenView(gameScore: score, onDismiss: { dismiss() }, viewModel: viewModel)
        } else {
            EndScreenView(
                gameScore: GameScore(
                    id: UUID().uuidString,
                    date: Date(),
                    targetScore: targetScore,
                    playerScore: viewModel.userScore,
                    computerScore: viewModel.computerScore
                ),
                onDismiss: { dismiss() }, viewModel: viewModel
            )
        }
    }
}

#Preview {
    GameView(targetScore: .constant(550), viewModel: GameViewModel())
}

struct ComputerView: View {
    // MARK: Properties
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 20.0) {
            Image("robot")
                .resizable()
                .frame(width: 80, height: 80)
            
            DiceImagesView(values: viewModel.computerDiceValues, isComputer: true, viewModel: viewModel)
            
            Text("Computer Score: \(viewModel.computerScore)")
        }
    }
}

struct UserView: View {
    // MARK: Properties
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 20.0) {
            Text("Your Score: \(viewModel.userScore)")
            
            DiceImagesView(values: viewModel.userDiceValues, isComputer: false, viewModel: viewModel)
                .allowsHitTesting(viewModel.isUserTurn)
            
            Image("user")
                .resizable()
                .frame(width: 80, height: 80)
        }
    }
}

struct GameButtons: View {
    // MARK: Properties
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        VStack(spacing: 8.0) {
            if viewModel.isUserTurn && !viewModel.hasThrown {
                Button {
                    viewModel.rollUserDice()
                } label: {
                    ButtonView(buttonTxt: viewModel.reRolls > 0 ? "Throw" : "No Rerolls Left")
                }
                .disabled(!viewModel.isUserTurn || viewModel.reRolls == 0 || viewModel.isRolling)
            }
            
            if !viewModel.isUserTurn {
                Text("Computer's turn")
                    .font(.title2)
                    .bold()
            } else if viewModel.hasThrown {
                Text("Reroll's left: \(viewModel.reRolls)")
                    .font(.title3)
                    .bold()
            }
            
            if viewModel.isUserTurn && (viewModel.hasThrown || viewModel.isRolling) {
                Button {
                    viewModel.scoreCurrentRoll()
                } label: {
                    ButtonView(buttonTxt: "Score")
                }
            }
        }
    }
}

struct DiceImagesView: View {
    // MARK: Properties
    var values: [Int]
    var isComputer: Bool
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(values.indices, id: \.self) { index in
                let value = values[index]
                
                Button {
                    if !isComputer { viewModel.rollUserDie(at: index) }
                } label: {
                    Image("dice-\(value)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                .disabled(isComputer || !viewModel.isUserTurn)
            }
        }
    }
}
