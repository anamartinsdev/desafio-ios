import XCTest
import SnapshotTesting

@testable import DesignSystem

final class CoraNavigationBarSnapshotTests: XCTestCase {
    func testCoraNavigationBar() {
        let navigationBar = CoraNavigationBar()
        navigationBar.frame = CGRect(x: 0, y: 0, width: 375, height: 64)
        navigationBar.configure(title: "Login Cora", showBackButton: false)
        assertSnapshot(matching: navigationBar, as: .image)
    }
    
    func testCoraNavigationBarWithBackButton() {
        let navigationBar = CoraNavigationBar()
        navigationBar.frame = CGRect(x: 0, y: 0, width: 375, height: 64)
        navigationBar.configure(title: "Login Cora")
        assertSnapshot(matching: navigationBar, as: .image)
    }
    
    func testCoraNavigationBarWithBackButtonAndActionImage() {
        let navigationBar = CoraNavigationBar()
        navigationBar.frame = CGRect(x: 0, y: 0, width: 375, height: 64)
        navigationBar.configure(title: "Login Cora", actionImage: UIImage(systemName: "arrow.forward"))
        assertSnapshot(matching: navigationBar, as: .image)
    }
    
    func testCoraNavigationBarWithoutBackButtonAndActionImage() {
        let navigationBar = CoraNavigationBar()
        navigationBar.frame = CGRect(x: 0, y: 0, width: 375, height: 64)
        navigationBar.configure(title: "Login Cora", showBackButton: false, actionImage: UIImage(systemName: "arrow.forward"))
        assertSnapshot(matching: navigationBar, as: .image)
    }
}
