//
//  RulesView.swift
//  Roll the Dice
//
//  Created by Abdul Moiz on 17/09/2025.
//

import SwiftUI

struct RulesView: View {
    // MARK: Properties
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: Background
                Color("MainBG")
                    .ignoresSafeArea()
                
                // MARK: Rules
                GameRules()
                
                Spacer()
            }
            .navigationTitle("Rules of the Game")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct GameRules: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    RuleCard(
                        title: "🎲 Taking Turns",
                        details: [
                            "You and your opponent take turns rolling 5 dice at once."
                        ]
                    )
                    
                    RuleCard(
                        title: "📊 Scoring",
                        details: [
                            "Add up the values of all 5 dice — that total is your score for the round."
                        ]
                    )
                    
                    RuleCard(
                        title: "🔄 Rerolls",
                        details: [
                            "Not happy with your roll? You can reroll specific dice by tapping them.",
                            "You may reroll up to 3 times per turn.",
                            "After your third roll, you must keep the result."
                        ]
                    )
                    
                    RuleCard(
                        title: "🏆 Winning the Game",
                        details: [
                            "The goal is to reach the target score before your opponent.",
                            "If both players reach or exceed the target score in the same round:",
                            "The player whose score is closest to the target wins.",
                            "If both are equally close, the game ends in a draw."
                        ]
                    )
                }
                .padding()
            }
            .background(Color("MainBG").ignoresSafeArea())
            .navigationTitle("Rules of the Game")
        }
    }
}

struct RuleCard: View {
    // MARK: Properties
    var title: String
    var details: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(.white)
            
            ForEach(details, id: \.self) { detail in
                Text("• \(detail)")
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.white.opacity(0.9))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.red.opacity(0.7))
        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
        .shadow(radius: 4)
    }
}

#Preview {
    RulesView()
}
