//
//  TranslationService.swift
//  Project6_iOS102
//
//  Created by Mario Casas on 10/18/25.
//

import Foundation

class TranslationService {
    func translate(text: String, from sourceLang: String = "en", to targetLang: String = "fr", completion: @escaping (String?) -> Void) {
        var components = URLComponents(string: "https://api.mymemory.translated.net/get")!
        components.queryItems = [
            URLQueryItem(name: "q", value: text),
            URLQueryItem(name: "langpair", value: "\(sourceLang)|\(targetLang)")
        ]

        guard let url = components.url else {
            print("❌ Invalid URL generated from components")
            completion(nil)
            return
        }

        print("📡 Requesting URL: \(url)")

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("❌ No data received from API.")
                completion(nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let responseData = json["responseData"] as? [String: Any],
                   let translatedText = responseData["translatedText"] as? String {
                    print("✅ Translated text: \(translatedText)")
                    completion(translatedText)
                } else {
                    print("❌ Unexpected JSON structure.")
                    completion(nil)
                }
            } catch {
                print("❌ JSON parse error: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
}


