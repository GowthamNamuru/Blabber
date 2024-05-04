//
//  DataModels.swift
//  Blabber
//
//  Created by Gowtham Namuru on 02/05/24.
//

import Foundation

struct Message: Identifiable {
    let id: UUID
    let user: String?
    let message: String
    var date: Date
}

extension Message {
  init(message: String) {
    self.id = .init()
    self.date = .init()
    self.user = nil
    self.message = message
  }
}
