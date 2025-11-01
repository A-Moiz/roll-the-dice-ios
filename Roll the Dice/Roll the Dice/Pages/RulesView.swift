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
                Image("WitchingHour")
                    .resizable()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 25) {
                        HStack {
                            Image(systemName: "book.fill")
                                .font(.system(size: 36))
                            Text("Rules of the Game")
                                .font(.system(size: 32,
                                              weight: .heavy,
                                              design: .rounded))
                        }
                        .padding(.top, 20)
                        
                        // MARK: Rule Cards
                        GameRules()
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .padding(8)
                    }
                    .shadow(radius: 4)
                }
            }
        }
    }
}

struct GameRules: View {
    var body: some View {
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
                    "Add up the values of all 5 dice - that total is your score for the round."
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
                    "If both are have the same score, there is a tiebreaker round"
                ]
            )
        }
    }
}

struct RuleCard: View {
    // MARK: Properties
    var title: String
    var details: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 22,
                              weight: .bold,
                              design: .rounded))
                .shadow(color: .black.opacity(0.5),
                        radius: 2, x: 1, y: 1)
            
            ForEach(details, id: \.self) { detail in
                Text("• \(detail)")
                    .font(.system(size: 16, design: .rounded))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10,
                                    style: .continuous))
        .shadow(color: .black.opacity(0.3),
                radius: 6, x: 2, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 10,
                             style: .continuous)
                .stroke(Color.white.opacity(0.2),
                        lineWidth: 1)
        )
    }
}

#Preview {
    RulesView()
}
