//
//  ContentView.swift
//  Roll the Dice
//
//  Created by Abdul Moiz on 15/09/2025.
//

import SwiftUI

struct HomeView: View {
    // MARK: Properties
    let columns: [GridItem] = [GridItem(.flexible(), spacing: 20),
                               GridItem(.flexible(), spacing: 20)]
    
    var buttons: [(buttonTxt: String, action: () -> Void)] {
        [
            ("New Game", newGame),
            ("Rules", rules),
            ("Reset Scores", resetScores),
            ("Game History", gameHistory)
        ]
    }
    @State var isShowingRules: Bool = false
    @State var startNewGame: Bool = false
    
    var body: some View {
        ZStack {
            // MARK: Background
            Color("MainBG")
                .ignoresSafeArea()
            
            VStack {
                Image("background")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: 250)
                    .ignoresSafeArea()
                
                Text("Roll the Dice")
                    .font(.system(size: 72,
                                  weight: .heavy,
                                  design: .rounded))
                    .foregroundStyle(.white)
                
                Spacer()
                
                LazyVGrid(columns: columns) {
                    ForEach(0..<buttons.count, id: \.self) { index in
                        let button = buttons[index]
                        Button(action: button.action) {
                            ButtonView(buttonTxt: button.buttonTxt)
                        }
                        .padding(.vertical, 10)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .sheet(isPresented: $isShowingRules) {
            RulesView()
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $startNewGame) {
            TargetSelectView()
                .presentationDetents([.medium])
        }
    }
    
    private func newGame() {
        startNewGame = true
    }
    
    private func rules() {
        isShowingRules = true
    }
    
    private func resetScores() {
        print("Reset Scores tapped")
    }
    
    private func gameHistory() {
        print("Game History tapped")
    }
}

#Preview {
    HomeView()
}
