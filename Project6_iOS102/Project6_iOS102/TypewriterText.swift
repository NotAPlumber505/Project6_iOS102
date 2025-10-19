//
//  TypewriterText.swift
//  Project6_iOS102
//
//  Created by Mario Casas on 10/18/25.
//

import Foundation

class TypewriterText: ObservableObject {
    @Published var displayedText = ""

    func animateText(_ fullText: String, speed: TimeInterval = 0.04) {
        displayedText = ""
        var index = 0
        Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
            if index < fullText.count {
                let char = fullText[fullText.index(fullText.startIndex, offsetBy: index)]
                self.displayedText.append(char)
                index += 1
            } else {
                timer.invalidate()
            }
        }
    }
}

