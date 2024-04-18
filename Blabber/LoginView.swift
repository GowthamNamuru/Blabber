//
//  LoginView.swift
//  Blabber
//
//  Created by Gowtham Namuru on 18/04/24.
//

import SwiftUI

struct LoginView: View {

    @State var username = ""
    @State var isDisplayingChat = false

    var body: some View {
        VStack {
            Text("Blabber")
                .font(.custom("Lemon", size: 48))
                .foregroundStyle(Color.teal)

            HStack {
                TextField(text: $username, prompt: Text("Username")) { }
                    .textFieldStyle(.roundedBorder)

                Button(action: {}, label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.teal)
                })
                .sheet(isPresented: $isDisplayingChat, onDismiss: {}, content: {
                    
                })
            }
            .padding(.horizontal)
        }
        .statusBar(hidden: true)
    }
}

#Preview {
    LoginView()
}
