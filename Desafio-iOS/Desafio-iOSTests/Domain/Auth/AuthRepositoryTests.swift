import XCTest
@testable import Desafio_iOS

final class AuthRepositoryTests: XCTestCase {
    
    var authService: CoraAuthServiceMock!
    var authUseCase: AuthUseCaseMock!
    var repository: AuthRepository!
    
    override func setUp() {
        super.setUp()
        authService = CoraAuthServiceMock(shouldReturnSuccess: true)
        authUseCase = AuthUseCaseMock()
        repository = AuthRepository(authService: authService, authUseCase: authUseCase)
    }
    
    override func tearDown() {
        authService = nil
        authUseCase = nil
        repository = nil
        super.tearDown()
    }
    
    func testAuthenticate_WithValidCredentials_ShouldReturnSuccess() {
        let expectedToken = "validToken123"
        authService.shouldReturnSuccess = true
        authService.token = expectedToken
        authUseCase.cpf = "validCPF"
        authUseCase.password = "validPassword"
        
        let expect = expectation(description: "Completion handler invoked")
        var success: Bool?
        var receivedToken: String?
        
        repository.authenticate { isSuccess, token in
            success = isSuccess
            receivedToken = token
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertTrue(success ?? false)
        XCTAssertEqual(receivedToken, expectedToken)
    }
    
    func testAuthenticate_WithInvalidCredentials_ShouldReturnFailure() {
        authService.shouldReturnSuccess = false
        authService.token = nil
        authUseCase.cpf = "invalidCPF"
        authUseCase.password = "invalidPassword"
        
        let expect = expectation(description: "Completion handler invoked")
        var success: Bool?
        var receivedToken: String?
        
        repository.authenticate { isSuccess, token in
            success = isSuccess
            receivedToken = token
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        
        XCTAssertFalse(success ?? true)
        XCTAssertNil(receivedToken)
    }
}
