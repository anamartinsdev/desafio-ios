import XCTest
@testable import CoraSecurity

final class CoraSecurityTests: XCTestCase {
    var keychainManager: KeychainManager!

    override func setUp() {
        super.setUp()
        keychainManager = KeychainManager()
    }

    override func tearDown() {
        try? keychainManager.delete(for: .cpf)
        try? keychainManager.delete(for: .password)
        try? keychainManager.delete(for: .token)
        keychainManager = nil
        super.tearDown()
    }

    func testSaveRetrieveDeleteCredential() {
        do {
            let cpf = "12345678900"
            try keychainManager.save(cpf, for: .cpf)
            
            let retrievedCPF = keychainManager.retrieve(for: .cpf)
            XCTAssertEqual(retrievedCPF, cpf, "Retrieved CPF should match the saved CPF.")
            
            try keychainManager.delete(for: .cpf)
            XCTAssertNil(keychainManager.retrieve(for: .cpf), "CPF should be nil after deletion.")
        } catch {
            XCTFail("Keychain operation failed with error: \(error).")
        }
    }

    func testUpdateCredential() {
        do {
            let initialCPF = "12345678900"
            try keychainManager.save(initialCPF, for: .cpf)

            let updatedCPF = "09876543210"
            try keychainManager.save(updatedCPF, for: .cpf)
            
            let retrievedCPF = keychainManager.retrieve(for: .cpf)
            XCTAssertEqual(retrievedCPF, updatedCPF, "Retrieved CPF should match the updated CPF.")
        } catch {
            XCTFail("Keychain operation failed with error: \(error).")
        }
    }

    func testRetrieveNonexistentCredential() {
        XCTAssertNil(keychainManager.retrieve(for: .token), "Retrieving a non-existent credential should return nil.")
    }
}
