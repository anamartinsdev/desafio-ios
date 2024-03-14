import Foundation
@testable import CoraNetwork

final class NetworkManagerMock: NetworkManagerProtocol {
    var token: String? = nil
    var data: Data?
    var response: URLResponse?
    var error: Error?
    var shouldAuthenticateSucceed: Bool = false
    var shouldUpdateTokenSucceed: Bool = false
    var mockToken: String? = "mockToken"
    
    func performRequest(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        completion(data, response, error)
    }
    
    func updateTokenIfNeed(completion: @escaping (Bool) -> Void) {
        if shouldUpdateTokenSucceed {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func authenticate(cpf: String?, password: String?, completion: @escaping (Bool, String?) -> Void) {
        if shouldAuthenticateSucceed {
            completion(true, mockToken)
        } else {
            completion(false, nil)
        }
    }
}
