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
    // Computer
    @Published var computerScore: Int = 0
    @Published var isUserTurn: Bool = true
    @Published var computerDiceValues: [Int] = Array(repeating: 1, count: 6)
    @Published var computerReRolls: Int = 3
    @Published var didUserJustScore: Bool = false
    
    // End-game state
    @Published var showEnd: Bool = false
    @Published var winner: String = ""
    @Published var isTieBreaker: Bool = false
    @Published var awaitingTieBreakerRolls: Bool = false
    @Published var lastGameScore: GameScore? = nil
    
    @Published var userRounds: Int = 0
    @Published var computerRounds: Int = 0
    
    private let gameHistoryKey = "gameHistoryKey_RollTheDice"
    
    @Published var gameHistory: [GameScore] = [] {
        didSet {
            saveGameHistory()
        }
    }
    
    var isFirstPlayerUser: Bool = true
    var currentRound: Int = 1

    init() {
        loadGameHistory()
    }
    
    // MARK: Save game history using User defaults
    private func saveGameHistory() {
        guard let data = try? JSONEncoder().encode(gameHistory) else { return }
        UserDefaults.standard.set(data, forKey: gameHistoryKey)
    }
    
    // MARK: Load game history from user defaults
    private func loadGameHistory() {
        if let data = UserDefaults.standard.data(forKey: gameHistoryKey),
           let decoded = try? JSONDecoder().decode([GameScore].self, from: data) {
            gameHistory = decoded
        }
    }
    
    // MARK: Throw user Dice
    func rollUserDice() {
        guard isUserTurn else { return }
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
        guard isUserTurn else { return }
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
                self.reRolls -= 1
            }
        }
    }
    
    // MARK: Score current user roll and reset for next turn
    func scoreCurrentRoll() {
        // Prevent scoring during roll animation
        guard !isRolling, hasThrown else { return }
        let roundScore = userDiceValues.reduce(0, +)
        userScore += roundScore
        reRolls = 3
        hasThrown = false
        isUserTurn = false
        didUserJustScore = true
        userRounds += 1
    }
    
    // MARK: Roll computer's dice
    private func rollComputerDice() {
        withAnimation(.easeInOut(duration: 0.4)) {
            isRolling = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring()) {
                self.computerDiceValues = (0..<6).map { _ in Int.random(in: 1...6) }
                self.isRolling = false
            }
        }
    }

    // MARK: Computer Dice reroll
    private func rerollComputerDice(using indices: [Int]) {
        guard !indices.isEmpty else { return }
        withAnimation(.easeInOut(duration: 0.25)) {
            isRolling = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.spring()) {
                for i in indices where self.computerDiceValues.indices.contains(i) {
                    self.computerDiceValues[i] = Int.random(in: 1...6)
                }
                self.isRolling = false
            }
        }
    }

    /// Simple heuristic: reroll dice less than 4 to try to maximize sum
    private func indicesToRerollForMaximizingSum(from values: [Int]) -> [Int] {
        values.enumerated().compactMap { idx, val in val < 4 ? idx : nil }
    }

    /// Plays the computer turn with up to 3 rerolls, then scores.
    @MainActor
    func playComputerTurn() async {
        // Small pause before starting so users notice the handoff
        try? await Task.sleep(nanoseconds: 350_000_000)
        
        // Initial roll
        rollComputerDice()
        // Wait for the animation/roll to complete and linger a bit for visibility
        try? await Task.sleep(nanoseconds: 700_000_000)
        computerReRolls = 3

        while computerReRolls > 0 {
            // Brief pause before deciding which dice to reroll
            try? await Task.sleep(nanoseconds: 300_000_000)
            let indices = indicesToRerollForMaximizingSum(from: computerDiceValues)
            // If no beneficial rerolls, stop early
            if indices.isEmpty { break }
            
            // Reroll selected dice
            rerollComputerDice(using: indices)
            // Wait for reroll animation and allow user to perceive changes
            try? await Task.sleep(nanoseconds: 600_000_000)
            computerReRolls -= 1
            
            // Heuristic: if sum is already high, stop early
            let sum = computerDiceValues.reduce(0, +)
            if sum >= 24 { // tweak threshold if desired
                break
            }
        }

        // Short pause before scoring so the final state is visible
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        // Score computer's roll
        let roundScore = computerDiceValues.reduce(0, +)
        computerScore += roundScore

        // Reset for next user turn
        computerReRolls = 3
        isUserTurn = true
        computerRounds += 1
    }
    
    // MARK: End Game Evaluation
    func evaluateEndCondition(target: Int) {
        // Prevent evaluation while rolling animations are happening
        if isRolling { return }

        let user = userScore
        let computer = computerScore
        let userHasReachedTarget = user >= target
        let computerHasReachedTarget = computer >= target

        // Wait until both have played the round
        if userRounds == computerRounds {
            // Handle tie-breaker rounds
            if isTieBreaker {
                if user != computer {
                    finalizeWinner(user: user, computer: computer, target: target)
                }
                return
            }

            if userHasReachedTarget || computerHasReachedTarget {
                if userHasReachedTarget && computerHasReachedTarget {
                    if user == computer {
                        startTieBreaker()
                    } else {
                        finalizeWinner(user: user, computer: computer, target: target)
                    }
                } else if userHasReachedTarget {
                    winner = "user"
                    buildAndStoreScore(user: user, computer: computer, target: target)
                    showEnd = true
                } else if computerHasReachedTarget {
                    winner = "computer"
                    buildAndStoreScore(user: user, computer: computer, target: target)
                    showEnd = true
                }
            }
        }
    }

    // MARK: Tier breaker round
    func startTieBreaker() {
        isTieBreaker = true
        awaitingTieBreakerRolls = false
        userRounds = 0
        computerRounds = 0
    }

    // MARK: Check winner
    func finalizeWinner(user: Int, computer: Int, target: Int) {
        isTieBreaker = false
        awaitingTieBreakerRolls = false
        if user > computer {
            winner = "user"
        } else if computer > user {
            winner = "computer"
        } else {
            winner = "draw"
        }
        buildAndStoreScore(user: user, computer: computer, target: target)
        showEnd = true
        userRounds = 0
        computerRounds = 0
    }

    // MARK: Saves game details
    private func buildAndStoreScore(user: Int, computer: Int, target: Int) {
        let newScore = GameScore(
            id: UUID().uuidString,
            date: Date(),
            targetScore: target,
            playerScore: user,
            computerScore: computer
        )
        lastGameScore = newScore
        gameHistory.append(newScore)
    }
    
    // MARK: Reset game
    func reset() {
        userDiceValues = Array(repeating: 1, count: 6)
        isRolling = false
        hasThrown = false
        reRolls = 3
        userScore = 0
        computerScore = 0
        isUserTurn = true
        computerDiceValues = Array(repeating: 1, count: 6)
        computerReRolls = 3
        didUserJustScore = false
        showEnd = false
        winner = ""
        isTieBreaker = false
        awaitingTieBreakerRolls = false
        lastGameScore = nil
        userRounds = 0
        computerRounds = 0
    }
}

