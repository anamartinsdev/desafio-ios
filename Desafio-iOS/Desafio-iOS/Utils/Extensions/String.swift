import Foundation

extension String {
    func inserting(separator: String, every n: Int) -> String {
        var result = ""
        self.enumerated().forEach { index, character in
            if index % n == 0 && index > 0 {
                result.append(separator)
            }
            result.append(character)
        }
        return result
    }
    
    func inserting(separator: String, at index: Int) -> String {
        guard index > 0 && index < self.count else { return self }
        
        let start = self.index(self.startIndex, offsetBy: index)
        let end = self.index(start, offsetBy: self.count - index)
        
        return String(self[..<start]) + separator + String(self[start..<end])
    }
}
