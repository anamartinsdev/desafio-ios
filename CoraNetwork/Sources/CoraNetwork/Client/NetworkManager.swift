import Foundation

public protocol NetworkManagerProtocol {
    var token: String? { get set }
    func performRequest(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
    func updateTokenIfNeed(completion: @escaping (Bool) -> Void)
    func authenticate(cpf: String?, password: String?, completion: @escaping (Bool, String?) -> Void)
}

public class NetworkManager: NetworkManagerProtocol {
    public var token: String?
    private let queue = DispatchQueue(label: NetworkConfiguration.queueIdentifier, attributes: .concurrent)
    private let session: URLSession
    private var isTokenRefreshing = false
    
    public init(session: URLSession = .shared, token: String? = nil, isTokenRefreshing: Bool = false) {
        self.session = session
        self.token = token
        self.isTokenRefreshing = isTokenRefreshing
    }
    
    public func performRequest(request: URLRequest, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        session.dataTask(with: request) { [ weak self] data, response, error in
            guard let self = self else { return }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                self.updateTokenIfNeed { success in
                    if success {
                        var newRequest = request
                        newRequest.setValue(self.token, forHTTPHeaderField: "token")
                        self.performRequest(request: newRequest, completion: completion)
                    } else {
                        completion(nil, nil, error)
                    }
                }
            } else {
                completion(nil, nil, error)
            }
        } .resume()
    }
    
    public func updateTokenIfNeed(completion: @escaping (Bool) -> Void) {
        queue.async(flags: .barrier) {
            guard !self.isTokenRefreshing else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            self.isTokenRefreshing = true
            self.authenticate { [weak self] success, newToken in
                guard let self = self else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                if success, let newToken = newToken {
                    self.queue.async(flags: .barrier) {
                        self.token = newToken
                        self.isTokenRefreshing = false
                        DispatchQueue.main.async {
                            completion(true)
                        }
                    }
                } else {
                    self.queue.async(flags: .barrier) {
                        self.isTokenRefreshing = false
                        DispatchQueue.main.async {
                            completion(false)
                        }
                    }
                }
            }
        }
    }
    
    
    public func authenticate(cpf: String? = nil, password: String? = nil, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(NetworkConfiguration.baseURL)/auth") else {
            completion(false, "Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = cpf != nil && password != nil
        ? ["cpf": cpf ?? "", "password": password ?? ""]
        : ["token": token ?? ""]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let data = data,
                  let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                  let json = jsonObject as? [String: Any],
                  let newToken = json["token"] as? String else {
                DispatchQueue.main.async {
                    completion(false, nil)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.token = newToken
                completion(true, newToken)
            }
        }.resume()
    }
}
