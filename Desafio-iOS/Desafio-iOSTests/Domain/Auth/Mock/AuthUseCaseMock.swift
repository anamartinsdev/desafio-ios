@testable import Desafio_iOS

final class AuthUseCaseMock: AuthUseCaseProtocol {
    var cpf: String?
    var password: String?
    
    func getCredentials() -> (String, String) {
        return (cpf ?? "", password ?? "")
    }
}

