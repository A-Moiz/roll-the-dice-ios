//
//  GameViewModel.swift
//  Roll the Dice
//
//  Created by Abdul Moiz on 03/10/2025.
//

import Foundation
import SwiftUI

class GameViewModel: ObservableObject {
    // MARK: Properties
    @Published var userDiceValues: [Int] = Array(repeating: 1, count: 6)
    @Published var isRolling = false
    @Published var hasThrown: Bool = false
    @Published var reRolls: Int = 3
    @Published var userScore: Int = 0
    @Published var computerScore: Int = 0
    
    // MARK: Throw user Dice
    func rollUserDice() {
        withAnimation(.easeInOut(duration: 0.5)) {
            isRolling = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.spring()) {
                self.userDiceValues = (0..<6).map { _ in Int.random(in: 1...6) }
                self.isRolling = false
                self.hasThrown = true
            }
        }
    }
    
    // MARK: Reroll a single user die at index
    func rollUserDie(at index: Int) {
        guard userDiceValues.indices.contains(index) else { return }
        // Prevent rolling if already animating or no rerolls left
        guard !isRolling, reRolls > 0 else { return }
        withAnimation(.easeInOut(duration: 0.2)) {
            isRolling = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring()) {
                self.userDiceValues[index] = Int.random(in: 1...6)
                self.isRolling = false
                // Decrement remaining rerolls after a successful roll
                self.reRolls -= 1
            }
        }
    }
    
    // MARK: Score current user roll and reset for next turn
    func scoreCurrentRoll() {
        // Prevent scoring during roll animation
        guard !isRolling else { return }
        // Sum current dice values and add to total user score
        let roundScore = userDiceValues.reduce(0, +)
        userScore += roundScore
        // Reset rerolls for the next turn
        reRolls = 3
        // Require a new throw before the next score
        hasThrown = false
    }
}
