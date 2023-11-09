//
//  ArticleDetailsPresenterTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//
@testable import NYTimes
import XCTest

class ArticleDetailsPresenterTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: ArticleDetailsPresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupArticleDetailsPresenter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupArticleDetailsPresenter() {
        sut = ArticleDetailsPresenter()
    }
    
    // MARK: Test doubles
    
    class ArticleDetailsDisplayLogicSpy: ArticleDetailsDisplayLogic {
        var displayArticleDetailsCalled = false
        
        func displayArticleDetails(viewModel: ArticleDetails.Get.ViewModel) {
            displayArticleDetailsCalled = true
        }
        
        func displayError(message: String) {
            
        }
    }
    
    // MARK: Tests
    
    func testPresentArticleDetails() {
        // Given
        let spy = ArticleDetailsDisplayLogicSpy()
        sut.viewController = spy
        let articlesData = AppUtility.readLocalFile(forName: "OneDayArticles")
        let article = Home.GetArticles.Response.from(data: articlesData)?.results?.first
        let docData = AppUtility.readLocalFile(forName: "SearchArticles")
        let doc = SearchArticles.Search.Response.from(data: docData)?.searchResponse?.docs?.first
        let response = ArticleDetails.Get.Response(article: article, doc: doc)
        
        // When
        sut.presentArticleDetails(response: response)
        
        // Then
        XCTAssertTrue(spy.displayArticleDetailsCalled, "presentSomething(response:) should ask the view controller to display the result")
    }
}
