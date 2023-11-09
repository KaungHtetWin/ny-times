//
//  ArticleDetailsInteractorTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

@testable import NYTimes
import XCTest

class ArticleDetailsInteractorTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: ArticleDetailsInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupArticleDetailsInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupArticleDetailsInteractor() {
        sut = ArticleDetailsInteractor()
    }
    
    // MARK: Test doubles
    
    class ArticleDetailsPresentationLogicSpy: ArticleDetailsPresentationLogic {
        var presentArticleDetailsCalled = false
        
        func presentArticleDetails(response: ArticleDetails.Get.Response) {
            presentArticleDetailsCalled = true
        }
        
    }
    
    // MARK: Tests
    
    func testDoGetArticleDetailsFromHome() {
        // Given
        let spy = ArticleDetailsPresentationLogicSpy()
        sut.presenter = spy
        let articlesData = AppUtility.readLocalFile(forName: "OneDayArticles")
        let article = Home.GetArticles.Response.from(data: articlesData)?.results?.first
        sut.article = article
        // When
        let request = ArticleDetails.Get.Request()
        sut.doGetArticleDetails(request: request)
        
        // Then
        XCTAssertTrue(spy.presentArticleDetailsCalled, "doGetArticleDetails(request:) should ask the presenter to format the result")
    }
    
    func testDoGetArticleDetailsFromSearch() {
        // Given
        let spy = ArticleDetailsPresentationLogicSpy()
        sut.presenter = spy
        let articlesData = AppUtility.readLocalFile(forName: "SearchArticles")
        let article = SearchArticles.Search.Response.from(data: articlesData)?.searchResponse?.docs?.first
        sut.doc = article
        // When
        let request = ArticleDetails.Get.Request()
        sut.doGetArticleDetails(request: request)
        
        // Then
        XCTAssertTrue(spy.presentArticleDetailsCalled, "doGetArticleDetails(request:) should ask the presenter to format the result")
    }
}
