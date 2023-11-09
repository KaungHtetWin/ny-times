//
//  ArticleDetailsVCTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

@testable import NYTimes
import XCTest

class ArticleDetailsVCTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: ArticleDetailsViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        sut = makeSUT()
    }
    
    override func tearDown() {
        super.tearDown()
        sut = nil
    }
    
    // MARK: Test setup
    
    func makeSUT() -> ArticleDetailsViewController {
        let sut = UIStoryboard.articlesDetailsViewController()!
        let spy = ArticleDetailsBusinessLogicSpy()
        sut.interactor = spy
        sut.loadViewIfNeeded()
        return sut
    }
    
    // MARK: Test doubles
    
    class ArticleDetailsBusinessLogicSpy: ArticleDetailsBusinessLogic {
        var doGetArticleDetailsCalled = false
        
        func doGetArticleDetails(request: ArticleDetails.Get.Request) {
            doGetArticleDetailsCalled = true
        }
    }
    
    // MARK: Tests
    
    func testShouldDoArticleDetailsWhenViewIsLoaded() {
        // Given
        let spy = ArticleDetailsBusinessLogicSpy()
        sut.interactor = spy
        // When
        sut.viewDidLoad()
        // Then
        XCTAssertTrue(spy.doGetArticleDetailsCalled, "viewDidLoad() should ask the interactor to do something")
    }
    
    func testDisplayArticleDetailsFromArticle() {
        // Given
        let articlesData = AppUtility.readLocalFile(forName: "OneDayArticles")
        let article = Home.GetArticles.Response.from(data: articlesData)?.results?.first
        let viewModel = ArticleDetails.Get.ViewModel(article: article, doc: nil)
        // When
        sut.displayArticleDetails(viewModel: viewModel)
        // Then
        XCTAssertEqual(sut.lblTitle.text, "Under Scrutiny Over Gaza, Israel Points to Civilian Toll of U.S. Wars", "article title should be Under Scrutiny Over Gaza, Israel Points to Civilian Toll of U.S. Wars")
        XCTAssertEqual(sut.txtDesription.text, "Israeli officials say it is impossible to defeat Hamas without killing innocents, a lesson they argue Americans and their allies should understand.", "article description should be Israeli officials say it is impossible to defeat Hamas without killing innocents, a lesson they argue Americans and their allies should understand.")
        XCTAssertEqual(sut.lblByline.text, "By Michael Crowley and Edward Wong", "article description should be By Michael Crowley and Edward Wong")
        XCTAssertEqual(sut.lblSource.text, "New York Times", "article source New York Times")
        XCTAssertEqual(sut.lblPublicDate.text, "2023-11-07", "article public date 2023-11-07")
    }
    
    func testDisplayArticleDetailsFromDoc() {
        // Given
        let articlesData = AppUtility.readLocalFile(forName: "SearchArticles")
        let article = SearchArticles.Search.Response.from(data: articlesData)?.searchResponse?.docs?.first
        let viewModel = ArticleDetails.Get.ViewModel(article: nil, doc: article)
        // When
        sut.displayArticleDetails(viewModel: viewModel)
        // Then
        XCTAssertEqual(sut.lblTitle.text, "Myanmar Military Bombs Refugee Camp, Killing 29, Rebels Say", "article title should be Myanmar Military Bombs Refugee Camp, Killing 29, Rebels Say")
        XCTAssertEqual(sut.txtDesription.text, "Eleven of the dead were under 16, and 56 people were wounded, said the Kachin Independence Army, which controls the area.", "article description should be Eleven of the dead were under 16, and 56 people were wounded, said the Kachin Independence Army, which controls the area.")
        XCTAssertEqual(sut.lblByline.text, "By Sui-Lee Wee", "article description should be By Sui-Lee Wee")
        XCTAssertEqual(sut.lblSource.text, "The New York Times", "article source The New York Times")
        XCTAssertEqual(sut.lblPublicDate.text, "2023-10-10", "article public date 2023-11-07")
    }
    
    func testTappedOnReadMoreButton() {
        let articlesData = AppUtility.readLocalFile(forName: "SearchArticles")
        let article = SearchArticles.Search.Response.from(data: articlesData)?.searchResponse?.docs?.first
        let viewModel = ArticleDetails.Get.ViewModel(article: nil, doc: article)
        // When
        sut.displayArticleDetails(viewModel: viewModel)
        sut.btnReadMoreTapped(UIButton())
        // Then
        XCTAssertEqual(sut.articleURL, "https://www.nytimes.com/2023/10/10/world/asia/myanmar-refugees-killed.html", "article web url should be https://www.nytimes.com/2023/10/10/world/asia/myanmar-refugees-killed.html")
    }
}
