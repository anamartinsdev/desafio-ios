import CoraNetwork
import Foundation

protocol StatementRepositoryProtocol {
    func fetchStatement(completion: @escaping (Result<TransactionListResponse, Error>) -> Void)
}

final class StatementRepository: StatementRepositoryProtocol {
    
    private let service: CoraStatementListServiceProtocol
    
    init(service: CoraStatementListServiceProtocol = CoraStatementListService()) {
        self.service = service
    }
    
    func fetchStatement(completion: @escaping (Result<TransactionListResponse, Error>) -> Void) {
        service.fetchList { data, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let transactiongroup = try JSONDecoder().decode(TransactionListResponse.self, from: data)
                    completion(.success(transactiongroup))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(
                    NSError(
                        domain: "fetchStatementError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "No data and no error were received."]
                    )))
            }
        }
    }
}
