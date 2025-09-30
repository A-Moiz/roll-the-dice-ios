//
//  TargetSelectView.swift
//  Roll the Dice
//
//  Created by Abdul Moiz on 18/09/2025.
//

import SwiftUI

struct TargetSelectView: View {
    // MARK: Properties
    let columns: [GridItem] = [GridItem(.flexible(), spacing: 12),
                               GridItem(.flexible(), spacing: 12),
                               GridItem(.flexible(), spacing: 12)]
    let gameTargets = [100, 150, 175, 300, 350, 500]
    @State private var customTarget: Int?
    @State private var showCustomTargetInput: Bool = false
    @State private var customTargetText: String = ""
    @Environment(\.dismiss) var dismiss
    @State var targetScore: Int = 0
    var onStartGame: ((Int) -> Void)? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: Background
                Color("MainBG")
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    LazyVGrid(columns: columns) {
                        ForEach(gameTargets, id: \.self) { target in
                            Button {
                                targetScore = target
                                print(targetScore)
                            } label: {
                                ButtonView(buttonTxt: String(target))
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Button {
                        showCustomTargetInput = true
                    } label: {
                        ButtonView(buttonTxt: "Custom Target?")
                            .padding(.horizontal)
                    }
                    
                    Text("Game Target Score: \(targetScore)")
                        .font(.title2)
                        .padding(.top)
                    
                    Spacer()
                    
                    Button {
                        if targetScore > 0 {
                            onStartGame?(targetScore)
                            dismiss()
                        }
                    } label: {
                        ButtonView(buttonTxt: "Start Game")
                            .padding()
                    }
                    .disabled(targetScore == 0)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
            .sheet(isPresented: $showCustomTargetInput) {
                CustomTargetView(customTargetText: $customTargetText, showCustomTargetInput: $showCustomTargetInput, customTarget: $customTarget)
            }
            .onChange(of: customTarget) { _, newValue in
                if let v = newValue {
                    targetScore = v
                    print(targetScore)
                }
            }
            .navigationTitle("Select Game Target")
        }
    }
}

#Preview {
    TargetSelectView()
}
