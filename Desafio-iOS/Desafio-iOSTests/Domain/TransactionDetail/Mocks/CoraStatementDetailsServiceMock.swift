import Foundation
@testable import CoraNetwork

final class CoraStatementDetailsServiceMock: CoraStatementDetailsServiceProtocol {
    var data: Data?
    var error: Error?
    var lastTransactionId: String?

    func fetchDetails(forId transactionId: String, completion: @escaping (Data?, Error?) -> Void) {
        lastTransactionId = transactionId
        completion(data, error)
    }
}

