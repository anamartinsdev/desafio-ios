import Foundation

final class StatementTransactionMapper {
    
    func map(response: TransactionListResponse) -> [TransactionSection] {
        return response.results.map { group in
            let transactions = group.items.map { map(item: $0) }
            let formattedDate = convertDate(group.date)
            return TransactionSection(date: formattedDate, transactions: transactions)
        }
    }
    
    private func map(item: TransactionItem) -> Transaction {
        let type = item.entry.lowercased() == "debit" ? TransactionType.normal : TransactionType.reversed
        
        let amount = formatAmount(item.amount)
        
        let time = formatDateEvent(item.dateEvent)
        
        let entry = item.entry.lowercased() == "debit" ? TransactionEntryType.debit :TransactionEntryType.credit
        
        return Transaction(id: item.id, description: item.description, name: item.name, time: time, amount: amount, type: type, entry: entry)
    }
    
    private func formatDateEvent(_ dateEvent: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateEvent) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    private func formatAmount(_ amount: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        let amountDouble = Double(amount) / 100
        return numberFormatter.string(from: NSNumber(value: amountDouble)) ?? ""
    }
    
    private func convertDate(_ date: String) -> String {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd"
            inputFormatter.locale = Locale(identifier: "pt_BR")

            guard let dateObj = inputFormatter.date(from: date) else { return "" }

            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "EEEE - dd 'de' MMMM"
            outputFormatter.locale = Locale(identifier: "pt_BR")
            
            return outputFormatter.string(from: dateObj).capitalizingFirstLetter()
        }
}
