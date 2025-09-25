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
    @State var throwDice: Bool = false
    @State var userDiceValues: [Int] = Array(repeating: 1, count: 6)
    @State var isRolling = false
    
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
                        
                        DiceImagesView(values: Array(repeating: 3, count: 6), isComputer: true)
                    }
                    
                    Spacer()
                    Button {
                        rollUserDice()
                    } label: {
                        ButtonView(buttonTxt: "Throw")
                    }
                    Spacer()
                    
                    VStack(spacing: 20) {
                        DiceImagesView(values: userDiceValues, isComputer: false)
                        
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
        }
    }
    
    // MARK: Throw Dice
    private func rollUserDice() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isRolling = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.spring()) {
                userDiceValues = (0..<6).map { _ in Int.random(in: 1...6) }
                isRolling = false
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
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(values.indices, id: \.self) { index in
                let value = values[index]
                
                Button {
                    print("Dice \(index + 1) tapped with value \(value)")
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
