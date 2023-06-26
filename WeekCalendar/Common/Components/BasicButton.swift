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
                    .background(isEnabled ? Color.blue : Color.blue.opacity(0.3))
                    .cornerRadius(10)
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isEnabled ? Color.blue : Color.blue.opacity(0.3), lineWidth: 1)
            )
            .disabled(!isEnabled)
        case .secondary:
            Button(action: action) {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .foregroundColor(.black)
                    .background(Color.clear)
                    .cornerRadius(10)
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .disabled(!isEnabled)
        case .destructive:
            Button(action: action) {
                Text(title)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .foregroundColor(.white)
                    .background(isEnabled ? Color.Red.tone100 : Color.Red.tone100.opacity(0.3))
                    .cornerRadius(10)
                
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isEnabled ? Color.Red.tone100 : Color.Red.tone100.opacity(0.3), lineWidth: 1)
            )
            .disabled(!isEnabled)
        }
    }
}

