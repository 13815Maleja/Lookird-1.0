import XCTest
@testable import Lookird

@MainActor
final class ViewModelIntegrationTest: XCTestCase {
    
    var systemUnderTest: ViewModel!

    override func setUpWithError() throws {
        let database = SightingDataBase.shared
        database.container = SightingDataBase.setupContainer(inMemory: true)
        
        let createSightingUseCase = CreateSightingUseCase(sightingDatabase: database)
        let fetchAllSightingUseCase = FetchAllSightingUseCase(sightingDatabase: database)
        
        systemUnderTest = ViewModel(createSightingUseCase: createSightingUseCase, fetchAllSightingUseCase: fetchAllSightingUseCase)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateSighting() {
        //Guiven
        systemUnderTest.createNoteWith(title: "Tucan", text: "Victoria, Caldas", userId: "123")
        
        //When
        let sighting = systemUnderTest.notes.first
        
        //then
        XCTAssertNotNil(sighting)
        XCTAssertEqual(sighting?.title, "Tucan")
        XCTAssertEqual(sighting?.text, "Victoria, Caldas")
        XCTAssertEqual(sighting?.userId, "123")
        XCTAssertEqual(systemUnderTest.notes.count, 1, "Debería existir una bitacora en la base de datos")
    }
    
    func testCreateTwoSighting() {
        //Guiven
        systemUnderTest.createNoteWith(title: "Tucan", text: "Victoria, Caldas", userId: "123")
        systemUnderTest.createNoteWith(title: "Guacharaca", text: "Puerto Salgar, Cundinamarca", userId: "124")
        
        //When
        let firstSighting = systemUnderTest.notes.first
        let lastSighting = systemUnderTest.notes.last
        
        //then
        XCTAssertNotNil(firstSighting)
        XCTAssertEqual(firstSighting?.title, "Tucan")
        XCTAssertEqual(firstSighting?.text, "Victoria, Caldas")
        XCTAssertEqual(firstSighting?.userId, "123")
        XCTAssertNotNil(lastSighting)
        XCTAssertEqual(lastSighting?.title, "Guacharaca")
        XCTAssertEqual(lastSighting?.text, "Puerto Salgar, Cundinamarca")
        XCTAssertEqual(lastSighting?.userId, "124")
        
        XCTAssertEqual(systemUnderTest.notes.count, 2, "Debería existir dos bitacoras en la base de datos")
    }
    
    func testFeatchAllSighting() {
        //Guiven
        systemUnderTest.createNoteWith(title: "Tucan", text: "Victoria, Caldas", userId: "123")
        systemUnderTest.createNoteWith(title: "Guacharaca", text: "Puerto Salgar, Cundinamarca", userId: "124")
        
        //When
        let firstSighting = systemUnderTest.notes[0]
        let secondSighting = systemUnderTest.notes[1]
        
        //then
        XCTAssertEqual(systemUnderTest.notes.count, 2, "There should be two sighting in the database")
        XCTAssertEqual(firstSighting.title, "Tucan", "First sighting's title should be 'Tucan'")
        XCTAssertEqual(firstSighting.text, "Victoria, Caldas", "First sighting's text should be 'Victoria, Caldas'")
        XCTAssertEqual(firstSighting.userId, "123", "First sighting's userId should be '123'")
        XCTAssertEqual(secondSighting.title, "Guacharaca", "Second sighting's title should be 'Guacharaca'")
        XCTAssertEqual(secondSighting.text, "Puerto Salgar, Cundinamarca", "Second sighting's text should be 'Puerto Salgar, Cundinamarca'")
        XCTAssertEqual(secondSighting.userId, "124", "First sighting's userId should be '124 '")
    }
    
    func testUpdateSighting() {
        systemUnderTest.createNoteWith(title: "Tucan", text: "Victoria, Caldas", userId: "123")
        guard let sighting = systemUnderTest.notes.first else {
            XCTFail()
            return
        }
        
        systemUnderTest.updateNotesWith(identifier: sighting.identifier, newTitle: "Cacatuara", newText: "Quindío")
        systemUnderTest.fetchAllSighting()
        
        XCTAssertEqual(systemUnderTest.notes.count, 1, "Deberia existir solo una nota en la base de datos")
        XCTAssertEqual(systemUnderTest.notes[0].title, "Cacatuara")
        XCTAssertEqual(systemUnderTest.notes[0].text, "Quindío")
        
        
    }
    
    func testRemoveSighting() {
        systemUnderTest.createNoteWith(title: "Tucan", text: "Victoria, Caldas", userId: "123")
        systemUnderTest.createNoteWith(title: "Guacharaca", text: "Victoria, Caldas", userId: "124")
        systemUnderTest.createNoteWith(title: "Colibri", text: "La Dorada, Caldas", userId: "125")
        
        guard let sighting = systemUnderTest.notes.last else {
            XCTFail()
            return
        }
        
        systemUnderTest.removeNote(identifier: sighting.identifier)
        XCTAssertEqual(systemUnderTest.notes.count, 2, "Deberian existir 2 notas en la base de datos")
    }
    
    func testsRemoveSightinInDatabaseShouldThrowError() {
        systemUnderTest.removeNote(identifier: UUID())
        
        XCTAssertEqual(systemUnderTest.notes.count, 0)
        XCTAssertNotNil(systemUnderTest.databaseErorr)
        XCTAssertEqual(systemUnderTest.databaseErorr, DatabaseError.errorRemove)
    }

}

