import XCTest
@testable import Desafio_iOS

final class TransactionDetailRepositoryTests: XCTestCase {
    var service: CoraStatementDetailsServiceMock!
    var repository: TransactionDetailRepository!

    override func setUp() {
        super.setUp()
        service = CoraStatementDetailsServiceMock()
        repository = TransactionDetailRepository(detailService: service)
    }

    override func tearDown() {
        service = nil
        repository = nil
        super.tearDown()
    }

    func testFetchDetails_WithData_ShouldReturnSuccess() {
        let jsonData = """
        {
          "description": "Pagamento por serviços prestados",
          "label": "Pagamento recebido",
          "amount": 150000,
          "counterPartyName": "Empresa ABC LTDA",
          "id": "abcdef12-3456-7890-abcd-ef1234567890",
          "dateEvent": "2024-02-05T14:30:45Z",
          "recipient": {
            "bankName": "Banco XYZ",
            "bankNumber": "001",
            "documentNumber": "11223344000155",
            "documentType": "CNPJ",
            "accountNumberDigit": "9",
            "agencyNumberDigit": "7",
            "agencyNumber": "1234",
            "name": "Empresa ABC LTDA",
            "accountNumber": "987654"
          },
          "sender": {
            "bankName": "Banco ABC",
            "bankNumber": "002",
            "documentNumber": "99887766000112",
            "documentType": "CNPJ",
            "accountNumberDigit": "3",
            "agencyNumberDigit": "1",
            "agencyNumber": "5678",
            "name": "Empresa XYZ LTDA",
            "accountNumber": "543210"
          },
          "status": "COMPLETED"
        }
        """.data(using: .utf8)!
        service.data = jsonData
        repository.transactionId = "abcdef12-3456-7890-abcd-ef1234567890"

        let expect = expectation(description: "Completion handler invoked")
        
        repository.fetchDetails { result in
            if case .success(let transactionDetail) = result {
                XCTAssertEqual(transactionDetail.id, "abcdef12-3456-7890-abcd-ef1234567890")
            } else {
                XCTFail("Expected success with transaction detail, got \(result)")
            }
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testFetchDetails_WithErrorResponse_ShouldReturnError() {
        let error = NSError(domain: "test", code: 1, userInfo: nil)
        service.error = error
        repository.transactionId = "transaction_id"

        let expect = expectation(description: "Completion handler invoked")
        
        repository.fetchDetails { result in
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
