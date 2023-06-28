//
//  CheckBoxSelector.swift
//  WeekCalendar
//
//  Created by David Gomez on 27/06/2023.
//

import SwiftUI

struct CheckBoxSelector: View {
    @State var items: [String]
    @State var style: Style
    
    @State var selectedItems: [String]
    
    enum Style {
        case horizontal
        case vertical
    }
    
    var onSelectedItems: (([String]) -> Void)
    
    private func isSelected(_ item: String) -> Bool {
        selectedItems.contains(where: {$0 == item})
    }
    
    var body: some View {
        if style == .horizontal {
            HStack(spacing: 12) {
                Spacer()
                ForEach(items, id: \.self) { item in
                    VStack {
                        Text(item)
                            .font(.caption)
                            .foregroundColor(Color.Dark.tone90)
                        Image(systemName: isSelected(item) ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.Yellow.light100)
                    }
                    .onTapGesture {
                        if isSelected(item) {
                            selectedItems.removeAll(where: {$0 == item})
                        } else {
                            selectedItems.append(item)
                        }
                        
                        onSelectedItems(selectedItems)
                    }
                }
            }
        } else {
            VStack {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                            .font(.caption)
                            .foregroundColor(Color.Dark.tone90)
                        Image(systemName: isSelected(item) ? "checkmark.circle.fill" : "circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color.Yellow.medium)
                    }
                    .onTapGesture {
                        if isSelected(item) {
                            selectedItems.removeAll(where: {$0 == item})
                        } else {
                            selectedItems.append(item)
                        }
                        
                        onSelectedItems(selectedItems)
                    }
                }
            }
        }
    }
}
