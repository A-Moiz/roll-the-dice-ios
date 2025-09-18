//
//  CustomTargetView.swift
//  Roll the Dice
//
//  Created by Abdul Moiz on 18/09/2025.
//


import SwiftUI

struct CustomTargetView: View {
    @Binding var customTargetText: String
    @Binding var showCustomTargetInput: Bool
    @Binding var customTarget: Int?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Enter Custom Target")
                .font(.headline)
            
            TextField("100 - 1000", text: $customTargetText)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            // MARK: Validation message
            let value = Int(customTargetText)
            let isValid = (value ?? -1) >= 100 && (value ?? -1) <= 1000
            if !customTargetText.isEmpty && !isValid {
                Text("Please enter a number between 100 and 1000.")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
            
            HStack {
                Button {
                    customTargetText = ""
                    showCustomTargetInput = false
                } label: {
                    ButtonView(buttonTxt: "Cancel")
                }
                
                Button {
                    if let v = Int(customTargetText), v >= 100 && v <= 1000 {
                        customTarget = v
                        showCustomTargetInput = false
                        customTargetText = ""
                        print("Custom target set to: \(v)")
                    }
                } label: {
                    ButtonView(buttonTxt: "OK")
                }
                .disabled(!isValid)
            }
        }
        .padding()
        .presentationDetents([.fraction(0.3)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    @State var customTargetText: String = ""
    @State var showCustomTargetInput: Bool = true
    @State var customTarget: Int?
    CustomTargetView(customTargetText: $customTargetText,
                     showCustomTargetInput: $showCustomTargetInput,
                     customTarget: $customTarget)
}
