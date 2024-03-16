import Foundation

enum NetworkError: Error {
    case tokenAlreadyRefreshing
    case tokenRefreshFailed
    case invalidURL
    case invalidResponse
}
