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
    @Published var translations: [Translation] = []

    private var db = Firestore.firestore()

    func loadHistory() {
        db.collection("translations").order(by: "timestamp", descending: true).addSnapshotListener { snapshot, error in
            if let snapshot = snapshot {
                self.translations = snapshot.documents.compactMap { doc in
                    try? doc.data(as: Translation.self)
                }
            }
        }
    }

    func addTranslation(_ translation: Translation) {
        do {
            _ = try db.collection("translations").addDocument(from: translation)
        } catch {
            print("❌ Error adding translation: \(error.localizedDescription)")
        }
    }

    func clearHistory() {
        db.collection("translations").getDocuments { snapshot, error in
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    document.reference.delete()
                }
            }
        }
    }
}
