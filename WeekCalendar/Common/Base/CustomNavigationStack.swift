//
//  CustomNavigationStack.swift
//  WeekCalendar
//
//  Created by David Gomez on 26/06/2023.
//

import SwiftUI

struct CustomNavigationStack<Content>: View where Content: View {
    let content: Content
    @ObservedObject var viewmodel: BaseViewModel
    
    init(viewmodel: BaseViewModel, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.viewmodel = viewmodel
    }
    
    var body: some View {
        NavigationStack {
            content
        }
        .presentLoginAsModal(shouldNavigate: $viewmodel.shouldNavigateToLogin)
    }
}

extension View {
    func presentLoginAsModal(shouldNavigate: Binding<Bool>) -> some View {
        self.fullScreenCover(isPresented: shouldNavigate, content: {
                    LoginView()
                })
    }
}
