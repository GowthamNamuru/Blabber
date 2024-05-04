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
    @State var model = BlabberModel()

    var body: some View {
        VStack {
            Text("Blabber")
                .font(.custom("Lemon", size: 48))
                .foregroundStyle(Color.teal)

            HStack {
                TextField(text: $username, prompt: Text("Username")) { }
                    .textFieldStyle(.roundedBorder)

                Button(action: {
                    model.userName = username
                    self.isDisplayingChat = true
                }, label: {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.teal)
                })
                .sheet(isPresented: $isDisplayingChat, onDismiss: {}, content: {
                    ChatView(model: model)
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
