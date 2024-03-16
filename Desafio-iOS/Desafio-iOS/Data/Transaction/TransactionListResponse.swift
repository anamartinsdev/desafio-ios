import Foundation

struct TransactionItem: Codable {
    let id: String
    let description: String
    let label: String
    let entry: String
    let amount: Int
    let name: String
    let dateEvent: String
    let status: String
}

struct TransactionGroup: Codable {
    let items: [TransactionItem]
    let date: String
}

struct TransactionListResponse: Codable {
    let results: [TransactionGroup]
    let itemsTotal: Int
}
