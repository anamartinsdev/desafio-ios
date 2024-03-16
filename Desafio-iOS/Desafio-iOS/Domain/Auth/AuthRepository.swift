import CoraNetwork

protocol AuthRepositoryProtocol {
    func authenticate(completion: @escaping (Bool, String?) -> Void)
}

final class AuthRepository: AuthRepositoryProtocol {
    private let authService: CoraAuthServiceProtocol
    private let authUseCase: AuthUseCaseProtocol
    
    init(authService: CoraAuthServiceProtocol = CoraAuthService(),
         authUseCase: AuthUseCaseProtocol = AuthUseCase()) {
        self.authService = authService
        self.authUseCase = authUseCase
    }
    
    func authenticate(completion: @escaping (Bool, String?) -> Void) {
        let credentials = authUseCase.getCredentials()
        authService.login(
            cpf: credentials.0,
            password: credentials.1,
            completion: completion
        )
    }
}
