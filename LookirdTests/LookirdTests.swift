import XCTest
@testable import Lookird

final class LookirdTests: XCTestCase {

    func testNotesInitiaAlization() {
        let title = "Test Title"
        let text = "Test Text"
        let userId = "123"
        let date = Date()
        
        let note = Home(userId: userId, title: title, text: text, createdAt: date)
        
        XCTAssertEqual(note.title, title, "Title should be equal to Test Title")
        XCTAssertEqual(note.text, text)
        XCTAssertEqual(note.createdAt, date)
    }
    
    func testNoteEmptyText() {

        let title = "Test Title"
        let userId = "123"
        let date = Date()
  
        let note = Home(userId: userId, title: title, text: nil, createdAt: date)
        
        XCTAssertEqual(note.getText, "")
    }
}
