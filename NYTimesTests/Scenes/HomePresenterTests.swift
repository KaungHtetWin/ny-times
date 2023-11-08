//
//  HomePresenterTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//
@testable import NYTimes
import XCTest

class HomePresenterTests: XCTestCase
{
    // MARK: Subject under test
    
    var sut: HomePresenter!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupHomePresenter()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: Test setup
    
    func setupHomePresenter() {
        sut = HomePresenter()
    }
    
    // MARK: Test doubles
    
    class HomeDisplayLogicSpy: HomeDisplayLogic {
        var displayHomeCalled = false
        var displayErrorCalled = false
        var articleRateViewModel: Home.GetArticles.ViewModel?
        func displayHome(viewModel: Home.GetArticles.ViewModel) {
            displayHomeCalled = true
            articleRateViewModel = viewModel
        }
        
        func displayError(message: String) {
            displayErrorCalled = true
        }
    }
    
    // MARK: Tests
    
    func testPresentHome() {
        // Given
        let spy = HomeDisplayLogicSpy()
        sut.viewController = spy
        let articlesData = AppUtility.readLocalFile(forName: "OneDayArticles")
        guard let response = Home.GetArticles.Response.from(data: articlesData) else { return }
        // When
        sut.presentHome(response: response)
        
        // Then
        let article = spy.articleRateViewModel?.articles?.first
        XCTAssertTrue(spy.displayHomeCalled, "presentSomething(response:) should ask the view controller to display the result")
        XCTAssertEqual(article?.title, "Under Scrutiny Over Gaza, Israel Points to Civilian Toll of U.S. Wars", "first article title should be Under Scrutiny Over Gaza, Israel Points to Civilian Toll of U.S. Wars")
    }
    
    func testPresentErrorMessage() {
        // Given
        let spy = HomeDisplayLogicSpy()
        sut.viewController = spy
        // When
        sut.presentError(message: "Unit test error")
        // Then
        XCTAssertTrue(spy.displayErrorCalled, "presentError(response:) should ask the view controller to display the result")
    }
}
