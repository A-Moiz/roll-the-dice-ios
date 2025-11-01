//
//  GameScore.swift
//  Roll the Dice
//
//  Created by Abdul Moiz on 25/09/2025.
//

import Foundation

struct GameScore: Codable {
    let id: String
    let date: Date
    let targetScore: Int
    let playerScore: Int
    let computerScore: Int
    var result: String {
        // If at least 1 reaches target score
        if playerScore >= targetScore || computerScore >= targetScore {
            if playerScore > computerScore {
                return "Win"
            } else {
                return "Lose"
            }
        }
        
        // If both reach target score at the same time
        if playerScore >= targetScore && computerScore >= targetScore {
            if playerScore > computerScore {
                return "Win"
            } else {
                return "Lose"
            }
        }
        return ""
    }
}
