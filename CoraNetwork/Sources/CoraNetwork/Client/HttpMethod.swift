public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

enum NetworkError: Error {
    case tokenAlreadyRefreshing
    case tokenRefreshFailed
    case invalidURL
    case invalidResponse
}
