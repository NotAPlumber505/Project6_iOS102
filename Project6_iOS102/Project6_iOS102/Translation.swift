//
//  Translation.swift
//  Project6_iOS102
//
//  Created by Mario Casas on 10/18/25.
//

import Foundation

struct Translation: Identifiable, Codable {
    var id = UUID().uuidString
    var originalText: String
    var translatedText: String
    var timestamp: Date
}
