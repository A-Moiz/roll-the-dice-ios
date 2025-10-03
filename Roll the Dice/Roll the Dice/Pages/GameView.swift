//
//  GameView.swift
//  Roll the Dice
//
//  Created by Abdul Moiz on 25/09/2025.
//

import SwiftUI

struct GameView: View {
    // MARK: Properties
    @State var showAlert: Bool = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""
    @State var quitGame: Bool = false
    @Binding var targetScore: Int
    @State var isRolling = false
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("MainBG")
                    .ignoresSafeArea()
                
                VStack {
                    VStack(spacing: 20) {
                        Image("robot")
                            .resizable()
                            .frame(width: 80, height: 80)
                        
                        DiceImagesView(values: Array(repeating: 3, count: 6), isComputer: true, viewModel: viewModel)
                        
                        Text("Computer Score: \(viewModel.computerScore)")
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Button {
                            viewModel.rollUserDice()
                        } label: {
                            ButtonView(buttonTxt: viewModel.reRolls > 0 ? "Throw" : "No Rerolls Left")
                        }
                        .disabled(viewModel.reRolls == 0 || viewModel.isRolling)
                        
                        Text("Rerolls left: \(viewModel.reRolls)")
                            .font(.subheadline)
                            .foregroundStyle(viewModel.reRolls > 0 ? .white.opacity(0.8) : .red)
                        
                        Button {
                            viewModel.scoreCurrentRoll()
                        } label: {
                            ButtonView(buttonTxt: "Score")
                        }
                        .disabled(!viewModel.hasThrown || viewModel.isRolling)
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("Your Score: \(viewModel.userScore)")
                        
                        DiceImagesView(values: viewModel.userDiceValues, isComputer: false, viewModel: viewModel)
                        
                        Image("user")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle),
                      message: Text(alertMessage),
                      primaryButton: .destructive(Text("Quit"), action: { quitGame = true }),
                      secondaryButton: .cancel())
            }
            .fullScreenCover(isPresented: $quitGame) {
                HomeView()
            }
        }
    }
}

#Preview {
    GameView(targetScore: .constant(550))
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
                    viewModel.rollUserDie(at: index)
                } label: {
                    Image("dice-\(value)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
//                        .rotation3DEffect(
//                            Angle(degrees: isComputer ? 0 : Double.random(in: -20...20)),
//                            axis: (x: 1, y: 1, z: 0)
//                        )
                        .animation(.easeInOut(duration: 0.3), value: value)
                }
                .disabled(isComputer)
            }
        }
    }
}

