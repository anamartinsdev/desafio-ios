import CoraNetwork
import Foundation

protocol TransactionDetailRepositoryProtocol {
    var transactionId: String? { get set }
    func fetchDetails(completion: @escaping (Result<TransactionDetail, Error>) -> Void)
}

final class TransactionDetailRepository: TransactionDetailRepositoryProtocol {
    private let detailService: CoraStatementDetailsServiceProtocol
    var transactionId: String?
    
    
    init(detailService: CoraStatementDetailsServiceProtocol = CoraStatementDetailsService()) {
        self.detailService = detailService
    }
    
    func fetchDetails(completion: @escaping (Result<TransactionDetail, Error>) -> Void) {
        detailService.fetchDetails(forId: transactionId ?? "") { data, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let transactionDetail = try JSONDecoder().decode(TransactionDetail.self, from: data)
                    completion(.success(transactionDetail))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(
                    NSError(
                        domain: "fetchDetailsError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No data and no error were received."]
                    )))
            }
        }
    }
}
