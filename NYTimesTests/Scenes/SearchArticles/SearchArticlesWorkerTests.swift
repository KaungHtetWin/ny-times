//
//  SearchArticlesWorkerTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//
//

@testable import NYTimes
import XCTest

class SearchArticlesWorkerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: SearchArticlesWorker!
    
    // MARK: Test lifecycle
    override func setUp() {
        super.setUp()
        setupHomeWorker()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: Test setup
    
    func setupHomeWorker() {
        sut = SearchArticlesWorker()
        sut.apiManager = MockAPIManager()
    }
    
    // MARK: Tests
    
    func testGetArticleOneDayPeriod() {
        // Given
        let successExpectation = expectation(description: "search should response data")
        let request = SearchArticles.Search.Request(q: "Myanmar")
        // When
        sut.doSearchArticles(requestData: request, completed: { (JSONObject, error) in
            // Then
            XCTAssertNotNil(JSONObject, "doSearchArticles should response data")
            successExpectation.fulfill()
        })
        wait(for: [successExpectation], timeout: 3)
    }
}
