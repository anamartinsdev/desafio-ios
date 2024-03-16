import XCTest

@testable import CoraNetwork

final class NetworkManagerTests: XCTestCase {
    func testAuthenticateFailure() {
        let sessionMock = URLSessionMock()
        sessionMock.data = nil
        sessionMock.response = HTTPURLResponse(url: URL(string: "\(NetworkConfiguration.baseURL)/auth")!, statusCode: 401, httpVersion: nil, headerFields: nil)
        
        let manager = NetworkManager(session: sessionMock)
        
        let expectation = expectation(description: "Authentication should fail and not update token.")
        
        manager.authenticate(cpf: "12345678900", password: "password") { result, token in
            XCTAssertFalse(result)
            XCTAssertNil(token)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testAuthenticateSuccessUpdatesToken() {
        let sessionMock = URLSessionMock()
        sessionMock.data = "{\"token\":\"newToken123\"}".data(using: .utf8)
        sessionMock.response = HTTPURLResponse(url: URL(string: "\(NetworkConfiguration.baseURL)/auth")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let manager = NetworkManager(session: sessionMock)
        
        let expectation = expectation(description: "Authentication should succedd and update token.")
        
        manager.authenticate(cpf: "12345678900", password: "password") { result, token in
            XCTAssertTrue(result)
            XCTAssertEqual(token, "newToken123")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}
