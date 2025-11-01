import SwiftUI

struct GameHistory: View {
    // MARK: Properties
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("WitchingHour")
                    .resizable()
                    .ignoresSafeArea()
                
                // MARK: Content
                if viewModel.gameHistory.isEmpty {
                    VStack(spacing: 24) {
                        Spacer()
                        Image(systemName: "dice.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(.white.opacity(0.8))
                        
                        Text("No games played yet.")
                            .font(.title3.bold())
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text("Play your first game to start tracking history!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                        Spacer()
                    }
                    .multilineTextAlignment(.center)
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            ForEach(viewModel.gameHistory.reversed(), id: \.id) { score in
                                HistoryRow(score: score)
                                    .padding(.horizontal)
                                    .transition(.opacity.combined(with: .scale))
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Game History")
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

struct HistoryRow: View {
    // MARK: Properties
    let score: GameScore
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(dateString)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                Spacer()
                Text(resultString)
                    .font(.headline.weight(.bold))
                    .foregroundColor(resultColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.ultraThinMaterial)
                    )
                    .clipShape(Capsule())
            }
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🎯 Target: \(score.targetScore)")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.95))
                    
                    Text("👤 You: \(score.playerScore)")
                        .font(.body)
                        .foregroundColor(.white)
                    
                    Text("🤖 Computer: \(score.computerScore)")
                        .font(.body)
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.2), radius: 4, y: 3)
    }
    
    // MARK: Computed Properties
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: score.date)
    }
    
    private var resultString: String {
        switch score.result {
        case "Win": return "Win"
        case "Lose": return "Loss"
        default: return "Draw"
        }
    }
    
    private var resultColor: Color {
        switch score.result {
        case "Win": return .green
        case "Lose": return .red
        default: return .yellow
        }
    }
}

#Preview {
    GameHistory(viewModel: GameViewModel())
}
