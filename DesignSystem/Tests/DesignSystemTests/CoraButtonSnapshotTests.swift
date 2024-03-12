import XCTest
import SnapshotTesting

@testable import DesignSystem

final class CoraButtonSnapshotTests: XCTestCase {
    func testButtonPrimaryStyle() {
        let button = CoraButton(
            title: "Próximo",
            image: nil,
            style: .primary
        )
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        assertSnapshot(matching: button, as: .image)
    }
    
    func testButtonPrimaryStyleWithImage() {
        let button = CoraButton(
            title: "Próximo",
            image: UIImage(systemName: "arrow.forward"),
            style: .primary
        )
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        assertSnapshot(matching: button, as: .image)
    }
    
    func testButtonSecondaryStyle() {
        let button = CoraButton(
            title: "Próximo",
            image: nil,
            style: .secondary
        )
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        assertSnapshot(matching: button, as: .image)
    }
    
    func testButtonSecondaryStyleWithImage() {
        let button = CoraButton(
            title: "Próximo",
            image: UIImage(systemName: "arrow.forward"),
            style: .secondary
        )
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        assertSnapshot(matching: button, as: .image)
    }
    
    func testButtonDisableStyle() {
        let button = CoraButton(
            title: "Próximo",
            image: nil,
            style: .disable
        )
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        assertSnapshot(matching: button, as: .image)
    }
    
    func testButtonDisableStyleWithImage() {
        let button = CoraButton(
            title: "Próximo",
            image: UIImage(systemName: "arrow.forward"),
            style: .disable
        )
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        assertSnapshot(matching: button, as: .image)
    }
}
