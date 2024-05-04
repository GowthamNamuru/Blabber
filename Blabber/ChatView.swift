//
//  ChatView.swift
//  Blabber
//
//  Created by Gowtham Namuru on 18/04/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var model: BlabberModel

    /// The message that the user has typed.
    @State var message = ""

    @FocusState var isFocused: Bool

    /// The last error message that happened.
    @State var lastErrorMessage = "" {
      didSet {
        isDisplayingError = true
      }
    }

    @State var isDisplayingError = false

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ScrollViewReader { reader in
                    ForEach($model.messages) { message in
                        MessageView(message: message, myUser: model.userName)
                    }
                    .onChange(of: model.messages.count) { _, _ in
                        guard let last = model.messages.last else { return }

                        withAnimation(.easeOut) {
                            reader.scrollTo(last.id, anchor: .bottomTrailing)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            HStack {
                Button {
                    // To track location
                } label: {
                    Image(systemName: "location.circle.fill")
                        .font(.title)
                        .foregroundStyle(Color.gray)
                }

                Button {
                    // For timer
                } label: {
                    Image(systemName: "timer")
                        .font(.title)
                        .foregroundStyle(Color.gray)
                }
                
                TextField(text: $message, prompt: Text("Message")) {
                    Text("Enter Message")
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($isFocused)
                .onSubmit {
                    Task {
                      try await model.say(message)
                      message = ""
                    }
                    isFocused = true
                }

                Button {
                    // Send action
                    Task {
                      try await model.say(message)
                      message = ""
                    }
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                      .font(.title)
                }

            }
        }
        .padding()
        .onAppear {
            isFocused = true
        }
        .alert(Text("Error"), isPresented: $isDisplayingError, actions: {
            Button("Close", role: .cancel) {
                self.presentationMode.wrappedValue.dismiss()
            }
        }, message: {
            Text(lastErrorMessage)
        })
        .task {
            do {
                try await model.chat()
            } catch {
                lastErrorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    ChatView(model: BlabberModel())
}
