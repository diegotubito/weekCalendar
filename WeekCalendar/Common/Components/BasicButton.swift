//
//  BasicButton.swift
//  WeekCalendar
//
//  Created by David Gomez on 26/06/2023.
//

import SwiftUI

struct BasicButton: View {
    enum ButtonStyle {
        case primary
        case secondary
        case destructive
    }

    let title: String
    let style: ButtonStyle
    @Binding var isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        switch style {
        case .primary:
            Button(action: action) {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .foregroundColor(.white)
                    .background(isEnabled ? Color.Blue.tone300 : Color.Blue.tone300.opacity(0.3))
                    .cornerRadius(10)
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isEnabled ? Color.Blue.tone200 : Color.Blue.tone200.opacity(0.3), lineWidth: 1)
            )
            .disabled(!isEnabled)
        case .secondary:
            Button(action: action) {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .foregroundColor(Color.Yellow.light100)
                    .background(Color.clear)
                    .cornerRadius(10)
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.Yellow.light100, lineWidth: 1)
            )
            .disabled(!isEnabled)
        case .destructive:
            Button(action: action) {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .foregroundColor(Color.Neutral.tone80)
                    .background(isEnabled ? Color.Red.midnight : Color.Red.tone100.opacity(0.3))
                    .cornerRadius(10)
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isEnabled ? Color.clear : Color.Red.tone100.opacity(0.3), lineWidth: 1)
            )
            .disabled(!isEnabled)
        }
    }
}

