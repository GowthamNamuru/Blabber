//
//  BlabberModel.swift
//  Blabber
//
//  Created by Gowtham Namuru on 02/05/24.
//

import Foundation

class BlabberModel: ObservableObject {
    var userName = ""

    var urlSession = URLSession.shared

    init() {}

    /// Current live updates
    @Published var messages: [Message] = []
}
