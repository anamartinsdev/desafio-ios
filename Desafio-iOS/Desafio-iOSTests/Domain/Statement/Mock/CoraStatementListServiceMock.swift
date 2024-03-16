import Foundation
@testable import CoraNetwork

final class CoraStatementListServiceMock: CoraStatementListServiceProtocol {
    var data: Data?
    var error: Error?

    func fetchList(completion: @escaping (Data?, Error?) -> Void) {
        completion(data, error)
    }
}
