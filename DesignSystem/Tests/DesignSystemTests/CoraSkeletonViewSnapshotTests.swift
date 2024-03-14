import XCTest
import SnapshotTesting

@testable import DesignSystem

final class CoraSkeletonViewSnapshotTests: XCTestCase {
    func testCoraSkeletonStatement() {
        let skeletonView = CoraSkeletonView(frame: CGRect(x:0, y:0, width: 375, height: 640), type: .statement)
        skeletonView.layoutIfNeeded()
        assertSnapshot(matching: skeletonView, as: .image)
    }
    
    func testCoraSkeletonDetail() {
        let skeletonView = CoraSkeletonView(frame: CGRect(x:0, y:0, width: 375, height: 640), type: .detail)
        skeletonView.layoutIfNeeded()
        assertSnapshot(matching: skeletonView, as: .image)
    }
}
