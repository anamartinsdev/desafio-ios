import Foundation
import CoraSecurity

public protocol CoraStatementListServiceProtocol {
    func fetchList(completion: @escaping (Data?, Error?) -> Void)
}

public class CoraStatementListService: CoraStatementListServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    private let keychainManager: KeychainManagerProtocol
    
    public init(networkManager: NetworkManagerProtocol = NetworkManager(),
                keychainManager: KeychainManagerProtocol = KeychainManager()) {
        self.networkManager = networkManager
        self.keychainManager = keychainManager
    }
    
    public func fetchList(completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(NetworkConfiguration.baseURL)/list") else {
            completion(nil, NSError(domain: "Invalid URL", code: -1, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        request.setValue(NetworkConfiguration.apiKey, forHTTPHeaderField: "apikey")
        let token = keychainManager.retrieve(for: .token)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        
        networkManager.performRequest(request: request) { data, response, error in
            completion(data, error)
        }
    }
}
