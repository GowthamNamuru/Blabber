//
//  MessageView.swift
//  Blabber
//
//  Created by Gowtham Namuru on 04/05/24.
//

import SwiftUI

struct MessageView: View {
    @Binding var message: Message
    let myUser: String

    var body: some View {
        HStack {
            if myUser == message.user {
                Spacer()
            }
            VStack(alignment: myUser == message.user ? .trailing : .leading, content: {
                if let user = message.user {
                    HStack {
                        if myUser != message.user {
                            Text(user).font(.callout)
                        }
                    }
                }

                Text(message.message)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 8)
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .strokeBorder(color(for: message.user, myUser: myUser), lineWidth: 1.0)
                    }
            })
            if myUser != message.user && message.user != nil {
                Spacer()
            }
        }
        .padding(.vertical, 2)
        .frame(maxWidth: .infinity)
    }

    private func color(for userName: String?, myUser: String) -> Color {
        guard let userName = userName else {
            return Color.clear
        }
        return myUser == userName ? Color.teal : Color.orange
    }
}

#Preview {
    MessageView(message: .constant(Message(id: UUID(), user: "Gowtham", message: "Some Message", date: Date())), myUser: "Gowtham 2")
}
