//
//  Transaction.swift
//  Desafio-iOS
//
//  Created by Ana Carolina Martins Pessoa on 14/03/24.
//

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

// Definição da estrutura para o agrupamento de itens por data
struct TransactionGroup: Codable {
    let items: [TransactionItem]
    let date: String
}

// Definição da estrutura para a resposta completa da API
struct TransactionListResponse: Codable {
    let results: [TransactionGroup]
    let itemsTotal: Int
}

// Definição do modelo Transaction que será usado pela célula
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

// Estrutura para representar uma seção de transações
struct TransactionSection {
    let date: String
    let transactions: [Transaction]
}
