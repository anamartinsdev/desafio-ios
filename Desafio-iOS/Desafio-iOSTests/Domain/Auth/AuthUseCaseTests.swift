import XCTest
@testable import CoraSecurity
@testable import Desafio_iOS

final class AuthUseCaseTests: XCTestCase {
    
    var useCase: AuthUseCase!
    var mockKeychainManager: KeychainManagerMock!
    
    override func setUp() {
        super.setUp()
        mockKeychainManager = KeychainManagerMock()
        useCase = AuthUseCase(keychainManager: mockKeychainManager)
    }
    
    override func tearDown() {
        mockKeychainManager = nil
        useCase = nil
        super.tearDown()
    }
    
    func testGetCredentials_WithSavedCredentials_ShouldReturnCredentials() {
        let expectedCPF = "12345678900"
        let expectedPassword = "password123"
        
        try? mockKeychainManager.save(expectedCPF, for: .cpf)
        try? mockKeychainManager.save(expectedPassword, for: .password)
        
        let credentials = useCase.getCredentials()
        
        XCTAssertEqual(credentials.0, expectedCPF)
        XCTAssertEqual(credentials.1, expectedPassword)
    }
    
    func testGetCredentials_WithoutSavedCredentials_ShouldReturnEmptyStrings() {
        let credentials = useCase.getCredentials()
        
        XCTAssertTrue(credentials.0.isEmpty)
        XCTAssertTrue(credentials.1.isEmpty)
    }
}
