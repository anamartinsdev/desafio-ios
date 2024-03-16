import XCTest
import SnapshotTesting

@testable import DesignSystem

final class CoraTabSnapshotTests: XCTestCase {
    func testCoraTab() {
        let tab = CoraTabView(items: ["Tudo", "Entrada", "Saída", "Futuro"], icon: UIImage(systemName: "arrow.forward"))
        tab.frame = CGRect(x: 0, y: 0, width: 375, height: 64)
        assertSnapshot(matching: tab, as: .image)
    }
}
