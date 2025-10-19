//
//  HistoryViewModel.swift
//  Project6_iOS102
//
//  Created by Mario Casas on 10/18/25.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class HistoryViewModel: ObservableObject {
    @Published var history: [Translation] = []
    private let db = Firestore.firestore()
    private let collection = "translations"

    init() {
        fetchHistory()
    }

    func fetchHistory() {
        db.collection(collection)
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                self.history = documents.compactMap {
                    try? $0.data(as: Translation.self)
                }
            }
    }

    func saveTranslation(_ translation: Translation) {
        do {
            _ = try db.collection(collection).document(translation.id).setData(from: translation)
        } catch {
            print("❌ Error saving translation: \(error.localizedDescription)")
        }
    }

    func deleteHistory() {
        for item in history {
            db.collection(collection).document(item.id).delete()
        }
    }
}
