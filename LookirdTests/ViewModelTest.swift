import XCTest
@testable import Lookird

final class ViewModelTest: XCTestCase {
    
    var viewModel: ViewModel!

    override func setUpWithError() throws {
        viewModel = ViewModel(createSightingUseCase: CreateSightingMock(),
                              fetchAllSightingUseCase: FetchAllSightingUseCaseMock(),
                              updateSightingUseCase: UpdateSightingUseCaseMock(),
                              removeSightingUseCase: RemoveSightinUseCaseMock()
        )
    
    }

    override func tearDownWithError() throws {
        mockDatabase = []
    }
    
    func testCreateNote() {
        //Given
        let title = "Test Title"
        let text = "test Text"
        let userId = "123"
        
        //When
        viewModel.createNoteWith(title: title, text: text, userId: userId)
        
        //Then
        XCTAssertEqual(viewModel.notes.count, 1)
        XCTAssertEqual(viewModel.notes.first?.title, title)
        XCTAssertEqual(viewModel.notes.first?.text, text)
        XCTAssertEqual(viewModel.notes.first?.userId, userId)
    }
    
    func testCreateThreeNote() {
        //Given
        let title1 = "Test Title 1"
        let text1 = "test Text 1"
        let userId1 = "123"
        
        let title2 = "Test Title 2"
        let text2 = "test Text 2"
        let userId2 = "124"
        
        let title3 = "Test Title 3"
        let text3 = "test Text 3"
        let userId3 = "125"
        
        //When
        viewModel.createNoteWith(title: title1, text: text1, userId: userId1)
        viewModel.createNoteWith(title: title2, text: text2, userId: userId2)
        viewModel.createNoteWith(title: title3, text: text3, userId: userId3)
        
        //Then
        XCTAssertEqual(viewModel.notes.count, 3)
        XCTAssertEqual(viewModel.notes.first?.title, title1)
        XCTAssertEqual(viewModel.notes.first?.text, text1)
        XCTAssertEqual(viewModel.notes.first?.userId, userId1)
        XCTAssertEqual(viewModel.notes[1].title, title2)
        XCTAssertEqual(viewModel.notes[1].text, text2)
        XCTAssertEqual(viewModel.notes[1].userId, userId2)
        XCTAssertEqual(viewModel.notes[2].title, title3)
        XCTAssertEqual(viewModel.notes[2].text, text3)
        XCTAssertEqual(viewModel.notes[2].userId, userId3)
    }
    
    func testUpdateNote() {
        
        let title = "Test Title"
        let text = "test Text"
        let userId = "123"
        
        viewModel.createNoteWith(title: title, text: text, userId: userId)
        
        let newTitle = "New Test Title"
        let newText = "New test Text"
        
       if let identifier = viewModel.notes.first?.identifier {
           viewModel.updateNotesWith(identifier: identifier, newTitle: newTitle, newText: newText)
           XCTAssertEqual(viewModel.notes.first?.title, newTitle)
           XCTAssertEqual(viewModel.notes.first?.text, newText)
       } else {
           XCTFail("No note was created.")
        }
    }
    
    func testRemoveNote() {
        let title = "Test Title"
        let text = "test Text"
        let userId = "123"
        
        viewModel.createNoteWith(title: title, text: text, userId: userId)
        
        if let identifier = viewModel.notes.first?.identifier {
            viewModel.removeNote(identifier: identifier)
            XCTAssertTrue(viewModel.notes.isEmpty)
        } else {
            XCTFail("No note was created.")
        }
    }

}
