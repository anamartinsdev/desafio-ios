import Foundation

public struct Transaction {
    let id: String
    let description: String
    let name: String
    let time: String
    let amount: String
    let type: TransactionType
    let entry: TransactionEntryType
}

public enum TransactionType {
    case normal
    case reversed
}

public enum TransactionEntryType {
    case debit
    case credit
}

struct TransactionSection {
    let date: String
    let transactions: [Transaction]
}
