import Foundation

struct TransactionDetail: Decodable {
    let description: String
    let label: String
    let amount: Int
    let counterPartyName: String
    let id: String
    let dateEvent: String
    let recipient: Party
    let sender: Party
    let status: String
}

struct Party: Decodable {
    let bankName: String
    let bankNumber: String
    let documentNumber: String
    let documentType: String
    let accountNumberDigit: String
    let agencyNumberDigit: String
    let agencyNumber: String
    let name: String
    let accountNumber: String
}
