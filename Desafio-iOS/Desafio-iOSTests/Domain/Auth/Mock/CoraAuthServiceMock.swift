@testable import CoraNetwork

final class CoraAuthServiceMock: CoraAuthServiceProtocol {
    var shouldReturnSuccess: Bool
    var token: String?
    
    init(shouldReturnSuccess: Bool, token: String? = nil) {
        self.shouldReturnSuccess = shouldReturnSuccess
        self.token = token
    }
    
    func login(cpf: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        completion(shouldReturnSuccess, token)
    }
}
