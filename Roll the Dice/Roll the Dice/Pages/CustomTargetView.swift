//
//  CustomTargetView.swift
//  Roll the Dice
//
//  Created by Abdul Moiz on 18/09/2025.
//


import SwiftUI

struct CustomTargetView: View {
    // MARK: Properties
    @Binding var customTargetText: String
    @Binding var showCustomTargetInput: Bool
    @Binding var customTarget: Int?
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Enter Custom Target")
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundStyle(.primary)
            
            // MARK: Custom TextField
            ZStack(alignment: .leading) {
                if customTargetText.isEmpty {
                    Text("100 - 1000")
                        .padding(.leading, 14)
                }
                
                TextField("", text: $customTargetText)
                    .keyboardType(.numberPad)
                    .focused($isTextFieldFocused)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .fill(Color(.systemBackground).opacity(0.9))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(isTextFieldFocused ? Color("Accent1") : Color.gray.opacity(0.3), lineWidth: 2)
                            )
                            .shadow(color: isTextFieldFocused ? Color("Accent1").opacity(0.3) : .clear, radius: 6)
                    )
                    .font(.system(size: 20, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
            }
            .padding(.horizontal)
            .animation(.easeInOut(duration: 0.2), value: isTextFieldFocused)
            
            // MARK: Validation message
            let value = Int(customTargetText)
            let isValid = (value ?? -1) >= 100 && (value ?? -1) <= 1000
            
            if !customTargetText.isEmpty && !isValid {
                Text("Please enter a number between 100 and 1000.")
                    .font(.footnote)
                    .foregroundStyle(.red)
                    .transition(.opacity)
            }
            
            // MARK: Buttons
            HStack(spacing: 16) {
                Button {
                    customTargetText = ""
                    showCustomTargetInput = false
                    isTextFieldFocused = false
                } label: {
                    ButtonView(buttonTxt: "Cancel")
                }
                
                Button {
                    if let v = Int(customTargetText), v >= 100 && v <= 1000 {
                        customTarget = v
                        showCustomTargetInput = false
                        customTargetText = ""
                        isTextFieldFocused = false
                        print("Custom target set to: \(v)")
                    }
                } label: {
                    ButtonView(buttonTxt: "OK")
                }
                .disabled(!isValid)
                .opacity(isValid ? 1.0 : 0.6)
            }
        }
        .padding()
        .presentationDetents([.fraction(0.35)])
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    @Previewable @State var customTargetText: String = ""
    @Previewable @State var showCustomTargetInput: Bool = true
    @Previewable @State var customTarget: Int?
    CustomTargetView(customTargetText: $customTargetText,
                     showCustomTargetInput: $showCustomTargetInput,
                     customTarget: $customTarget)
}
