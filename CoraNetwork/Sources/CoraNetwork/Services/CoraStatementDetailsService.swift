import Foundation

public protocol CoraStatementDetailsServiceProtocol {
    func fetchDetails(forId id: String, completion: @escaping (Data?, Error?) -> Void)
}

public class CoraStatementDetailsService: CoraStatementDetailsServiceProtocol {
    private let networkManager: NetworkManagerProtocol
    
    public init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    public func fetchDetails(forId id: String, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: "\(NetworkConfiguration.baseURL)/details/\(id)")
        else {
            completion(nil, NSError(domain: "Invalid URL", code: -1, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        request.setValue(
            NetworkConfiguration.apiKey,
            forHTTPHeaderField: "apikey"
        )
        request.setValue(
            networkManager.token,
            forHTTPHeaderField: "token"
        )
        
        networkManager.performRequest(request: request) { data, response, error in
            completion(data, error)
        }
    }
}
