import Foundation

final class StatementTransactionMapper {
    
    func map(response: TransactionListResponse) -> [TransactionSection] {
            return response.results.map { group in
                // Converte cada TransactionItem em Transaction
                let transactions = group.items.map { map(item: $0) }
                // Cria uma seção com as transações mapeadas
                return TransactionSection(date: group.date, transactions: transactions)
            }
        }
        
        // Mapeia o TransactionItem individual para Transaction
        private func map(item: TransactionItem) -> Transaction {
            // Converte a entrada de 'entry' para TransactionType
            let type = item.entry.lowercased() == "debit" ? TransactionType.normal : TransactionType.reversed
            
            // Formata a quantidade em moeda
            let amount = formatAmount(item.amount)
            
            // Formata a data do evento
            let time = formatDateEvent(item.dateEvent)
            
            return Transaction(id: item.id, description: item.description, name: item.name, time: time, amount: amount, type: type)
        }
    
    private func formatDateEvent(_ dateEvent: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateEvent) {
            dateFormatter.dateFormat = "HH:mm" // or "h:mm a" for 12-hour format
            return dateFormatter.string(from: date)
        }
        return ""
    }
    
    private func formatAmount(_ amount: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current // Adjust if you want a different locale
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        
        let amountDouble = Double(amount) / 100 // Assuming amount is in cents
        return numberFormatter.string(from: NSNumber(value: amountDouble)) ?? ""
    }
}
