//
//  ContentView.swift
//  Project6_iOS102
//
//  Created by Mario Casas on 10/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText = ""
    @State private var translatedText = ""
    @ObservedObject private var historyVM = HistoryViewModel()
    private let translator = TranslationService()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("🇫🇷 BonMot!").font(.largeTitle).bold()

                TextField("Enter text to translate", text: $inputText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("✨ Translate") {
                    translateText()
                }
                .padding()
                .background(Color.blue.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(10)

                Text(translatedText)
                    .font(.title2)
                    .padding()

                Divider().padding()

                HStack {
                    Text("🕘 Translation History").bold()
                    Spacer()
                    Button("🗑 Clear") {
                        historyVM.deleteHistory()
                    }
                }.padding([.leading, .trailing])

                ScrollView {
                    ForEach(historyVM.history) { item in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("📝 \(item.originalText)")
                                .font(.subheadline)
                            Text("➡️ \(item.translatedText)")
                                .font(.body)
                        }
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                }

                Spacer()
            }
            .padding()
        }
    }

    private func translateText() {
        translator.translate(text: inputText) { result in
            DispatchQueue.main.async {
                if let result = result {
                    self.translatedText = result
                    let newTranslation = Translation(originalText: inputText, translatedText: result, timestamp: Date())
                    self.historyVM.saveTranslation(newTranslation)
                } else {
                    self.translatedText = "❌ Translation failed"
                }
            }
        }
    }
}

