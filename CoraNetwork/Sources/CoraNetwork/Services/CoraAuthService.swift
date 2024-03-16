import Foundation

public protocol CoraAuthServiceProtocol {
    func login(cpf: String, password: String, completion: @escaping (Bool, String?) -> Void)
}

public class CoraAuthService: CoraAuthServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    public init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    public func login(cpf: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        networkManager.authenticate(
            cpf: cpf,
            password: password,
            completion: { success, token in
                completion(success, token)
        })
    }
}
