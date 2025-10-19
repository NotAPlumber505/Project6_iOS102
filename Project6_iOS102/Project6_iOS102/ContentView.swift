//
//  ContentView.swift
//  Project6_iOS102
//
//  Created by Mario Casas on 10/18/25.
//

import SwiftUI

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var sourceLang = "en"
    @State private var targetLang = "fr"

    @StateObject private var historyVM = HistoryViewModel()
    @StateObject private var typewriter = TypewriterText()
    private let translationService = TranslationService()

    let languages = [
        "en": "English 🇺🇸",
        "fr": "French 🇫🇷",
        "es": "Spanish 🇪🇸",
        "de": "German 🇩🇪",
        "it": "Italian 🇮🇹"
    ]
    
    var body: some View {
        ZStack {
            // Background - Layer 0
            Image("eiffel")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(minWidth: 0, maxWidth: .infinity)
                .ignoresSafeArea()
                .blur(radius: 12)
                .allowsHitTesting(false)

            // Content - Layer 1
            ScrollView {
                VStack(spacing: 20) {
                    Text("BonMot 🇫🇷")
                        .font(.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.black)
                        .padding(.top)

                    // Language pickers
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Languages")
                            .font(.headline)
                            .foregroundColor(.black)

                        VStack {
                            HStack {
                                Text("From:")
                                    .foregroundColor(.black)

                                Picker("Source Language", selection: $sourceLang) {
                                    ForEach(languages.keys.sorted(), id: \.self) { code in
                                        Text(languages[code]!).tag(code)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 100)
                                .clipped()
                            }

                            HStack {
                                Text("To:")
                                    .foregroundColor(.black)

                                Picker("Target Language", selection: $targetLang) {
                                    ForEach(languages.keys.sorted(), id: \.self) { code in
                                        Text(languages[code]!).tag(code)
                                    }
                                }
                                .pickerStyle(WheelPickerStyle())
                                .frame(height: 100)
                                .clipped()
                            }
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                    }
                    
                    // ✅ TEXT FIELD GOES HERE - same level as other content
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Enter Text")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        TextField("Enter text to translate", text: $inputText)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    .padding(.horizontal)

                    // Translate button
                    Button(action: translateText) {
                        Text("Translate")
                            .bold()
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    // Output
                    VStack(alignment: .leading) {
                        Text("Translated Text")
                            .foregroundColor(.black)
                        Text(typewriter.displayedText.isEmpty ? "Translation will appear here..." : typewriter.displayedText)
                            .font(.title2)
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    Divider()

                    // History
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Translation History")
                            .font(.headline)
                            .foregroundColor(.black)

                        ForEach(historyVM.translations.sorted(by: { $0.timestamp > $1.timestamp })) { item in
                            VStack(alignment: .leading, spacing: 4) {
                                Text("🗣️ \(item.originalText)")
                                    .foregroundColor(.black)
                                Text("🔁 \(item.translatedText)")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)

                    // Clear history
                    Button("Clear History") {
                        historyVM.clearHistory()
                    }
                    .foregroundColor(.red)
                    .padding(.bottom, 40)
                }
            }
        }
        .onAppear {
            historyVM.loadHistory()
        }
    }

    func translateText() {
        translationService.translate(text: inputText, from: sourceLang, to: targetLang) { result in
            DispatchQueue.main.async {
                if let translated = result {
                    translatedText = translated
                    typewriter.animateText(translated)

                    let newTranslation = Translation(
                        originalText: inputText,
                        translatedText: translated,
                        timestamp: Date()
                    )
                    historyVM.addTranslation(newTranslation)
                } else {
                    typewriter.displayedText = "Translation failed"
                }
            }
        }
    }
}
