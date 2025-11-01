//
//  ButtonView.swift
//  Roll the Dice
//
//  Created by Abdul Moiz on 15/09/2025.
//

import SwiftUI

struct ButtonView: View {
    // MARK: Properties
    var buttonTxt: String
    
    var body: some View {
        Text(buttonTxt)
            .font(.system(size: 30, weight: .heavy, design: .rounded))
            .lineLimit(2)
            .minimumScaleFactor(0.6)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight: 60)
            .padding(.horizontal, 16)
            .background(
                Color("BrightYellow")
            )
            .foregroundColor(.black)
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 2, y: 2)
    }
}

#Preview {
    ButtonView(buttonTxt: "Reset Scores")
}
