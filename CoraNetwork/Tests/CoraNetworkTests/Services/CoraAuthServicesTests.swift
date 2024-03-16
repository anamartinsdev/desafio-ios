import XCTest

@testable import CoraNetwork

final class CoraAuthServicesTests: XCTestCase {
    var authService: CoraAuthService!
    var networkManagerMock: NetworkManagerMock!
    
    override func setUp() {
        super.setUp()
        networkManagerMock = NetworkManagerMock()
        authService = CoraAuthService(networkManager: networkManagerMock)
    }
    
    override func tearDown() {
        authService = nil
        networkManagerMock = nil
        super.tearDown()
    }
    
    func testLoginSuccess() {
        networkManagerMock.shouldAuthenticateSucceed = true
        
        let expectation = expectation(description: "Login Success")
        authService.login(cpf: "12345678900", password: "password") { result, token in
            XCTAssertTrue(result)
            XCTAssertEqual(token, "mockToken")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoginFailure() {
        networkManagerMock.shouldAuthenticateSucceed = false
        
        let expectation = expectation(description: "Login Failure")
        authService.login(cpf: "", password: "") { result, token in
            XCTAssertFalse(result)
            XCTAssertNil(token)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
