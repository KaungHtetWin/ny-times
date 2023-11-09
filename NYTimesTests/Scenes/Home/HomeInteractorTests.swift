//
//  HomeInteractorTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

@testable import NYTimes
import XCTest

class HomeInteractorTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: HomeInteractor!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupHomeInteractor()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: Test setup
    
    func setupHomeInteractor() {
        sut = HomeInteractor()
    }
    
    // MARK: Test doubles
    
    class HomePresentationLogicSpy: HomePresentationLogic {
        var presentHomeCalled = false
        var presentErrorCalled = false
        var articleResponse: Home.GetArticles.Response?
        var errorMessage: String?
        func presentArticles(response: Home.GetArticles.Response, period: Home.ArticlesPeriod) {
            presentHomeCalled = true
            articleResponse = response
        }
        
        func presentError(message: String) {
            presentErrorCalled = true
            errorMessage = message
        }
    }
    
    // MARK: Tests
    
    func testGetArticlesSuccess() {
        // Given
        let spy = HomePresentationLogicSpy()
        sut.presenter = spy
        let request = Home.GetArticles.Request()
        let mock = MockHomeWorker()
        sut.worker = mock
        // When
        sut.doGetArticles(request: request)
        
        // Then
        let articleResponse = spy.articleResponse
        XCTAssertTrue(spy.presentHomeCalled, "doGetHome(request:) should ask the presenter to format the result")
        XCTAssertEqual(articleResponse?.results?.first?.title, "Under Scrutiny Over Gaza, Israel Points to Civilian Toll of U.S. Wars", "first article title should be Under Scrutiny Over Gaza, Israel Points to Civilian Toll of U.S. Wars")
    }
    
    func testGrticlesJsonSerializeErrorResponse() {
        // Given
        let spy = HomePresentationLogicSpy()
        sut.presenter = spy
        let request = Home.GetArticles.Request()
        let mock = MockHomeWorker()
        mock.shouldReponseEmptyData = true
        sut.worker = mock
        // When
        sut.doGetArticles(request: request)
        // Then
        let errorMessage = spy.errorMessage
        XCTAssertTrue(spy.presentErrorCalled, "doGetHome(request:) should ask the presenter to show error")
        XCTAssertEqual(errorMessage, "Json Serialize Error", "error message shold be Json Serialize Error")
    }
    
    func testGrticlesSeverErrorResponse() {
        // Given
        let spy = HomePresentationLogicSpy()
        sut.presenter = spy
        let request = Home.GetArticles.Request()
        let mock = MockHomeWorker()
        mock.shouldReponseServerError = true
        sut.worker = mock
        // When
        sut.doGetArticles(request: request)
        // Then
        let errorMessage = spy.errorMessage
        XCTAssertTrue(spy.presentErrorCalled, "doGetHome(request:) should ask the presenter to show error")
        XCTAssertEqual(errorMessage, "Server Error", "error message shold be Server Error")
    }
    
    func testGrticlesApiKeyErrorResponse() {
        // Given
        let spy = HomePresentationLogicSpy()
        sut.presenter = spy
        let request = Home.GetArticles.Request()
        let mock = MockHomeWorker()
        mock.shouldReponseAppKeyError = true
        sut.worker = mock
        // When
        sut.doGetArticles(request: request)
        // Then
        let errorMessage = spy.errorMessage
        XCTAssertTrue(spy.presentErrorCalled, "doGetHome(request:) should ask the presenter to show error")
        XCTAssertEqual(errorMessage, "steps.oauth.v2.FailedToResolveAPIKey", "error message shold be steps.oauth.v2.FailedToResolveAPIKey")
    }
}

class MockHomeWorker: HomeWorkerLogic {
    var shouldReponseServerError = false
    var shouldReponseEmptyData = false
    var shouldReponseAppKeyError = false
    func doGetArticles(requestData: Home.GetArticles.Request, completed: @escaping ResponseDataCompletionHandler) {
        let articlesData = AppUtility.readLocalFile(forName: "OneDayArticles")
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
