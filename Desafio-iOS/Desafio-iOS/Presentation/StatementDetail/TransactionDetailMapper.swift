import Foundation

final class TransactionDetailMapper {
    static func map(_ transactionDetail: TransactionDetail) -> [([String], Int?)] {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        
        let currencyAmount = formatter.string(from: NSNumber(value: transactionDetail.amount / 100)) ?? "R$ \(transactionDetail.amount / 100)"

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: transactionDetail.dateEvent)!
        
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let displayDate = dateFormatter.string(from: date)

        let valueSection: ([String], Int?) = (["Valor", currencyAmount], 1)
        let dateSection: ([String], Int?) = (["Data", displayDate], 1)
        
        let fromSection: ([String], Int?) = (
            [
                "De",
                transactionDetail.sender.bankName,
                "\(transactionDetail.sender.documentType) \(format(documentNumber: transactionDetail.sender.documentNumber))",
                "Agência \(transactionDetail.sender.agencyNumber) - Conta \(transactionDetail.sender.accountNumber)-\(transactionDetail.sender.accountNumberDigit)"
            ],
            1
        )
        
        let toSection: ([String], Int?) = (
            [
                "Para",
                transactionDetail.recipient.bankName,
                "\(transactionDetail.recipient.documentType) \(format(documentNumber: transactionDetail.recipient.documentNumber))",
                "Agência \(transactionDetail.recipient.agencyNumber) - Conta \(transactionDetail.recipient.accountNumber)-\(transactionDetail.recipient.accountNumberDigit)"
            ],
            1
        )
        
        let descriptionSection: ([String], Int?) = (["Descrição", transactionDetail.description], nil)

        return [valueSection, dateSection, fromSection, toSection, descriptionSection]
    }
    
    private static func format(documentNumber: String) -> String {
        // Implement formatting logic depending on document type (CPF/CNPJ)
        // For example, here's a simplistic way to format CNPJ:
        let numbers = documentNumber.filter { "0"..."9" ~= $0 }
        if numbers.count == 14 { // Assuming it's CNPJ
            return numbers.inserting(separator: ".", every: 3)
                           .inserting(separator: "/", at: 8)
                           .inserting(separator: "-", at: 12)
        } else { // Assuming it's CPF
            return numbers.inserting(separator: ".", every: 3)
                           .inserting(separator: "-", at: 9)
        }
    }
}