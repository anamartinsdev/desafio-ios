import Foundation

public struct Transaction {
    let iconName: String
    let amount: String
    let description: String
    let name: String
    let time: String
    let type: TransactionType
}

public enum TransactionType {
    case received
    case payment
    case reverse
    case boletoDeposit
}
