import XCTest
import SnapshotTesting

@testable import DesignSystem

final class CoraStatementCellSnapshotTests: XCTestCase {
    func testCoraStatementCell() {
        let cell = CoraStatementCell(
            style: .default,
            reuseIdentifier: "TransactionCell"
        )
        let transaction = Transaction(
            iconName: "creditcard.fill",
            amount: "R$ 30,00",
            description: "Transação recebida",
            name: "Lucas Costa",
            time: "17:35",
            type: .payment
        )
        
        cell.configure(with: transaction)
        cell.frame = CGRect(x: 0, y: 0, width: 375, height: 80)
        cell.layoutIfNeeded()
        
        assertSnapshot(matching: cell, as: .image)
    }
}
