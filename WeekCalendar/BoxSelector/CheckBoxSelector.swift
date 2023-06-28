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
                ForEach(items, id: \.self) { item in
                    VStack {
                        Text(item)
                            .foregroundColor(Color.Dark.tone90)
                        Image(isSelected(item) ? "checkmark-circle" : "circle")
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
                Spacer()
            }
        } else {
            VStack {
                ForEach(items, id: \.self) { item in
                    HStack {
                        Text(item)
                            .foregroundColor(Color.Dark.tone90)
                        Spacer()
                        Image(isSelected(item) ? "checkmark-circle" : "circle")
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
