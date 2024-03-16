import XCTest
@testable import Desafio_iOS

final class StatementRepositoryTests: XCTestCase {

    var service: CoraStatementListServiceMock!
    var repository: StatementRepository!

    override func setUp() {
        super.setUp()
        service = CoraStatementListServiceMock()
        repository = StatementRepository(service: service)
    }

    override func tearDown() {
        service = nil
        repository = nil
        super.tearDown()
    }

    func testFetchStatement_WithData_ShouldReturnSuccess() {
        let jsonData = """
        {
          "results": [
            {
              "items": [
                {
                  "id": "abc123def456ghi789",
                  "description": "Compra de produtos eletrônicos",
                  "label": "Compra aprovada",
                  "entry": "DEBIT",
                  "amount": 150000,
                  "name": "João da Silva",
                  "dateEvent": "2024-02-01T08:15:17Z",
                  "status": "COMPLETED"
                }
              ],
              "date": "2024-02-01"
            }
          ],
          "itemsTotal": 1
        }
        """.data(using: .utf8)!
        service.data = jsonData
        
        let expect = expectation(description: "Completion handler invoked")
        
        repository.fetchStatement { result in
            if case .success(let transactionListResponse) = result {
                XCTAssertEqual(transactionListResponse.results.count, 1)
                XCTAssertEqual(transactionListResponse.itemsTotal, 1)
            } else {
                XCTFail("Expected success with empty transaction list, got \(result)")
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchStatement_WithErrorResponse_ShouldReturnError() {
        let error = NSError(domain: "test", code: 1, userInfo: nil)
        service.error = error

        let expect = expectation(description: "Completion handler invoked")
        
        repository.fetchStatement { result in
            if case .failure(let error as NSError) = result {
                XCTAssertEqual(error.domain, "test")
                XCTAssertEqual(error.code, 1)
            } else {
                XCTFail("Expected failure, got \(result)")
            }
            expect.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }
}
