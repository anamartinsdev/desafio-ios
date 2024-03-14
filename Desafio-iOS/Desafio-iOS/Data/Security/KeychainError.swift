import Security

enum KeychainError: Error {
    case unhandledError(status: OSStatus)
}
