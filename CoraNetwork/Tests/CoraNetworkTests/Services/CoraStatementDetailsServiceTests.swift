import XCTest
@testable import CoraNetwork

final class CoraStatementDetailsServiceTests: XCTestCase {
    var detailsService: CoraStatementDetailsService!
    var networkManagerMock: NetworkManagerMock!
    
    override func setUp() {
        super.setUp()
        networkManagerMock = NetworkManagerMock()
        detailsService = CoraStatementDetailsService(networkManager: networkManagerMock)
    }
    
    override func tearDown() {
        detailsService = nil
        networkManagerMock = nil
        super.tearDown()
    }
    
    func testFetchDetailsSuccess() {
        let expectedData = "{\"key\":\"value\"}".data(using: .utf8)
        networkManagerMock.data = expectedData
        networkManagerMock.response = HTTPURLResponse(url: URL(string: "\(NetworkConfiguration.baseURL)/details/1234")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        let expectation = self.expectation(description: "Fetch details succeeds")
        
        detailsService.fetchDetails(forId: "1234") { data, error in
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            XCTAssertEqual(data, expectedData)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchDetailsFailure() {
        networkManagerMock.data = nil
        networkManagerMock.response = HTTPURLResponse(url: URL(string: "\(NetworkConfiguration.baseURL)/details/1234")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        networkManagerMock.error = NSError(domain: "network", code: -1009, userInfo: nil)
        
        let expectation = self.expectation(description: "Fetch details fails")
        
        detailsService.fetchDetails(forId: "1234") { data, error in
            XCTAssertNil(data)
            XCTAssertNotNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
