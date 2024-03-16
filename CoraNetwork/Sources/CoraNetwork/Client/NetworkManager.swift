import Foundation
import CoraSecurity

public protocol NetworkManagerProtocol {
    var token: String? { get set }
    func performRequest(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func authenticate(cpf: String?, password: String?, completion: @escaping (Bool, String?) -> Void)
}

public class NetworkManager: NetworkManagerProtocol {
    private let queue = DispatchQueue(
        label: NetworkConfiguration.queueIdentifier,
        attributes: .concurrent
    )
    private let session: URLSession
    private var isTokenRefreshing = false
    private let keychainManager: KeychainManagerProtocol
    private var tokenExpirationDate: Date?
    private var pendingRequests: [(URLRequest, (Data?, URLResponse?, Error?) -> Void)] = []
    
    public var token: String? {
        get {
            return keychainManager.retrieve(for: .token)
        }
        set {
            guard let newValue = newValue else {
                try? keychainManager.delete(for: .token)
                return
            }
            try? keychainManager.save(
                newValue,
                for: .token
            )
        }
    }
    
    public init(session: URLSession = .shared,
                isTokenRefreshing: Bool = false,
                keychainManager: KeychainManagerProtocol = KeychainManager()) {
        self.session = session
        self.isTokenRefreshing = isTokenRefreshing
        self.keychainManager = keychainManager
    }
    
    public func performRequest(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        queue.sync {
            if let expirationDate = self.tokenExpirationDate, Date() < expirationDate, !isTokenRefreshing {
                self.sendRequest(
                    request,
                    completion: completion
                )
                return
            }
            
            if isTokenRefreshing {
                self.pendingRequests.append((request, completion))
                return
            }
            
            self.updateToken {
                self.sendRequest(
                    request,
                    completion: completion
                )
            }
        }
    }
    
    private func sendRequest(_ request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var modifiedRequest = request
        if let token = self.token {
            modifiedRequest.setValue(
                token,
                forHTTPHeaderField: "token"
            )
        }
        modifiedRequest.setValue(
            NetworkConfiguration.apiKey,
            forHTTPHeaderField: "apikey"
        )
        
        self.session.dataTask(with: modifiedRequest) { data, response, error in
            DispatchQueue.main.async {
                completion(data, response, error)
            }
        }.resume()
    }
    
    public func authenticate(cpf: String?, password: String?, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(NetworkConfiguration.baseURL)/auth") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue(
            NetworkConfiguration.apiKey,
            forHTTPHeaderField: "apikey"
        )
        
        let body: [String: Any] = ["cpf": cpf ?? "", "password": password ?? ""]
        request.httpBody = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, error.localizedDescription)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(false, NetworkError.invalidResponse.localizedDescription)
                }
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                guard let data = data,
                      let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let newToken = jsonObject["token"] as? String else {
                    DispatchQueue.main.async {
                        completion(false, "Invalid data")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    // Armazena o novo token e chama o completion com sucesso
                    self.token = newToken
                    completion(true, newToken)
                }
                
            case 401:
                DispatchQueue.main.async {
                    completion(false, NetworkError.tokenRefreshFailed.localizedDescription)
                }
                
            default:
                DispatchQueue.main.async {
                    completion(false, "Unexpected status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }

    
    private func updateToken(completion: @escaping () -> Void) {
        isTokenRefreshing = true
        
        guard let url = URL(string: "\(NetworkConfiguration.baseURL)/auth") else {
            completion()
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.setValue(
            NetworkConfiguration.apiKey,
            forHTTPHeaderField: "apikey"
        )
        
        let body: [String: Any] = ["token": token ?? ""]
        request.httpBody = try? JSONSerialization.data(
            withJSONObject: body,
            options: []
        )
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            defer {
                DispatchQueue.main.async {
                    self.isTokenRefreshing = false
                    completion()
                }
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let newToken = json["token"] as? String else {
                DispatchQueue.main.async {
                    self.pendingRequests.forEach { _, completion in
                        completion(nil, nil, NetworkError.tokenRefreshFailed)
                    }
                    self.pendingRequests.removeAll()
                }
                return
            }
            
            self.token = newToken
            self.tokenExpirationDate = Calendar.current.date(
                byAdding: .minute,
                value: 1,
                to: Date()
            )
            
            DispatchQueue.main.async {
                self.pendingRequests.forEach { request, completion in
                    self.sendRequest(
                        request,
                        completion: completion
                    )
                }
                self.pendingRequests.removeAll()
            }
        }.resume()
    }
}
