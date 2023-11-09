//
//  SearchArticlesInteractorTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

@testable import NYTimes
import XCTest

class SearchArticlesInteractorTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: SearchArticlesInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupSearchArticlesInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupSearchArticlesInteractor() {
        sut = SearchArticlesInteractor()
    }
    
    // MARK: Test doubles
    
    class SearchArticlesPresentationLogicSpy: SearchArticlesPresentationLogic {
        var presentSearchCalled = false
        var presentErrorCalled = false
        var articleResponse: SearchArticles.Search.Response?
        var errorMessage: String?
        func presentSearchArticles(response: SearchArticles.Search.Response) {
            presentSearchCalled = true
            articleResponse = response
        }
        
        func presentError(message: String) {
            presentErrorCalled = true
            errorMessage = message
        }
    }
    
    // MARK: Tests
    
    func testDoSearchArticles() {
        // Given
        let spy = SearchArticlesPresentationLogicSpy()
        sut.presenter = spy
        let request = SearchArticles.Search.Request(q: "Myanmar")
        let mock = MockSearchArticlesWorker()
        sut.worker = mock
        // When
        sut.doGetSearchArticles(request: request)
        // Then
        let articleResponse = spy.articleResponse
        XCTAssertTrue(spy.presentSearchCalled, "doGetSearchArticles(request:) should ask the presenter to format the result")
        XCTAssertEqual(articleResponse?.searchResponse?.docs?.first?.abstract,
                       "Eleven of the dead were under 16, and 56 people were wounded, said the Kachin Independence Army, which controls the area.",
                       "first article title should be Eleven of the dead were under 16, and 56 people were wounded, said the Kachin Independence Army, which controls the area.")
    }
    
    func testSearchArticlesJsonSerializeErrorResponse() {
        // Given
        let spy = SearchArticlesPresentationLogicSpy()
        sut.presenter = spy
        let request = SearchArticles.Search.Request(q: "Myanmar")
        let mock = MockSearchArticlesWorker()
        mock.shouldReponseEmptyData = true
        sut.worker = mock
        // When
        sut.doGetSearchArticles(request: request)
        // Then
        let errorMessage = spy.errorMessage
        XCTAssertTrue(spy.presentErrorCalled, "doGetSearchArticles(request:) should ask the presenter to show error")
        XCTAssertEqual(errorMessage, "Json Serialize Error", "error message shold be Json Serialize Error")
    }
    
    func testGrticlesSeverErrorResponse() {
        // Given
        let spy = SearchArticlesPresentationLogicSpy()
        sut.presenter = spy
        let request = SearchArticles.Search.Request(q: "Myanmar")
        let mock = MockSearchArticlesWorker()
        mock.shouldReponseServerError = true
        sut.worker = mock
        // When
        sut.doGetSearchArticles(request: request)
        // Then
        let errorMessage = spy.errorMessage
        XCTAssertTrue(spy.presentErrorCalled, "doGetSearchArticles(request:) should ask the presenter to show error")
        XCTAssertEqual(errorMessage, "Server Error", "error message shold be Server Error")
    }
    
    func testGrticlesApiKeyErrorResponse() {
        // Given
        let spy = SearchArticlesPresentationLogicSpy()
        sut.presenter = spy
        let request = SearchArticles.Search.Request(q: "Myanmar")
        let mock = MockSearchArticlesWorker()
        mock.shouldReponseAppKeyError = true
        sut.worker = mock
        // When
        sut.doGetSearchArticles(request: request)
        // Then
        let errorMessage = spy.errorMessage
        XCTAssertTrue(spy.presentErrorCalled, "doGetSearchArticles(request:) should ask the presenter to show error")
        XCTAssertEqual(errorMessage, "steps.oauth.v2.FailedToResolveAPIKey", "error message shold be steps.oauth.v2.FailedToResolveAPIKey")
    }
}


class MockSearchArticlesWorker: SearchArticlesWorkerLogic {
    
    var shouldReponseServerError = false
    var shouldReponseEmptyData = false
    var shouldReponseAppKeyError = false
    
    func doSearchArticles(requestData: SearchArticles.Search.Request, completed: @escaping ResponseDataCompletionHandler) {
        let articlesData = AppUtility.readLocalFile(forName: "SearchArticles")
        let articlesErrorData = AppUtility.readLocalFile(forName: "ErrorArticles")
        if shouldReponseServerError {
            completed(nil, APIError.ServerError)
        } else if shouldReponseEmptyData {
            completed(nil, nil)
        } else if shouldReponseAppKeyError {
            completed(articlesErrorData, nil)
        } else {
            completed(articlesData, nil)
        }
    }
}
