//
//  SearchArticlesPresenterTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//
@testable import NYTimes
import XCTest

class SearchArticlesPresenterTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: SearchArticlesPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupSearchArticlesPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupSearchArticlesPresenter() {
        sut = SearchArticlesPresenter()
    }
    
    // MARK: Test doubles
    
    class SearchArticlesDisplayLogicSpy: SearchArticlesDisplayLogic {
        var displaySearchArticlesCalled = false
        var displayErrorCalled = false
        var searchArticleViewModel: SearchArticles.Search.ViewModel?
        func displaySearchArticles(viewModel: SearchArticles.Search.ViewModel) {
            displaySearchArticlesCalled = true
            searchArticleViewModel = viewModel
        }
        
        func displayError(message: String) {
            displayErrorCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentSearchArticles() {
        // Given
        let spy = SearchArticlesDisplayLogicSpy()
        sut.viewController = spy
        let articlesData = AppUtility.readLocalFile(forName: "SearchArticles")
        guard let response = SearchArticles.Search.Response.from(data: articlesData) else { return }
        // When
        sut.presentSearchArticles(response: response)
        
        // Then
        let article = spy.searchArticleViewModel?.docs?.first
        XCTAssertTrue(spy.displaySearchArticlesCalled, "presentSearchArticles(response:) should ask the view controller to display the result")
        XCTAssertEqual(article?.abstract,
                       "Eleven of the dead were under 16, and 56 people were wounded, said the Kachin Independence Army, which controls the area.",
                       "first article title should be Eleven of the dead were under 16, and 56 people were wounded, said the Kachin Independence Army, which controls the area.")
    }
    
    func testPresentErrorMessage() {
        // Given
        let spy = SearchArticlesDisplayLogicSpy()
        sut.viewController = spy
        // When
        sut.presentError(message: "Unit test error")
        // Then
        XCTAssertTrue(spy.displayErrorCalled, "presentError(response:) should ask the view controller to display the result")
    }
}
