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
                                print(target)
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
                    
                    Spacer()
                    
                    Button {
                        // TODO: Go to Game view with game target score
                    } label: {
                        ButtonView(buttonTxt: "Star Game")
                            .padding()
                    }
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
            .navigationTitle("Select Game Target")
        }
    }
}

#Preview {
    TargetSelectView()
}
