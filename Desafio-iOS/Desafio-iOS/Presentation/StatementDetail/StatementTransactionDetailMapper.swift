import Foundation

final class StatementTransactionDetailMapper {
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
        let displayDate = formattedDateDescription(from: date)

        let valueSection: ([String], Int?) = (
            [
                "Valor",
                currencyAmount
            ],
            1
        )
        let dateSection: ([String], Int?) = (
            [
                "Data",
                displayDate
            ],
            1
        )
        
        let fromSection: ([String], Int?) = (
            [
                "De",
                transactionDetail.sender.name,
                "\(transactionDetail.sender.documentType) \(format(documentNumber: transactionDetail.sender.documentNumber))",
                transactionDetail.sender.bankName,
                "Agência \(transactionDetail.sender.agencyNumber) - Conta \(transactionDetail.sender.accountNumber)-\(transactionDetail.sender.accountNumberDigit)"
            ],
            1
        )
        
        let toSection: ([String], Int?) = (
            [
                "Para",
                transactionDetail.recipient.name,
                "\(transactionDetail.recipient.documentType) \(format(documentNumber: transactionDetail.recipient.documentNumber))",
                transactionDetail.recipient.bankName,
                "Agência \(transactionDetail.recipient.agencyNumber) - Conta \(transactionDetail.recipient.accountNumber)-\(transactionDetail.recipient.accountNumberDigit)"
            ],
            1
        )
        
        let descriptionSection: ([String], Int?) = (
            [
                "Descrição",
                transactionDetail.description
            ],
            nil
        )

        return [
            valueSection,
            dateSection,
            fromSection,
            toSection,
            descriptionSection
        ]
    }
    
    private static func format(documentNumber: String) -> String {
        let numbers = documentNumber.filter { "0"..."9" ~= $0 }
        if numbers.count == 14 {
            return numbers.inserting(
                separator: ".",
                every: 3
            )
            .inserting(
                separator: "/",
                at: 8
            )
            .inserting(
                separator: "-",
                at: 12
            )
        } else {
            return numbers.inserting(
                separator: ".",
                every: 3
            )
            .inserting(
                separator: "-",
                at: 9
            )
        }
    }
    
    private static func formattedDateDescription(from date: Date) -> String {
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                return "Hoje - \(formatDate(date))"
            } else if calendar.isDateInYesterday(date) {
                return "Ontem - \(formatDate(date))"
            } else {
                return "\(weekday(for: date)) - \(formatDate(date))"
            }
        }

        private static func formatDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "pt_BR")
            dateFormatter.dateFormat = "dd/MM/yyyy"
            return dateFormatter.string(from: date)
        }

        private static func weekday(for date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "pt_BR")
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: date).capitalized
        }

}
