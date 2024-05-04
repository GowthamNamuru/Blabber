//
//  ChatView.swift
//  Blabber
//
//  Created by Gowtham Namuru on 18/04/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var model: BlabberModel

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ScrollViewReader { reader in
                    ForEach($model.messages) { message in
                        
                    }
                }
            }
        }
    }
}

#Preview {
    ChatView(model: BlabberModel())
}
