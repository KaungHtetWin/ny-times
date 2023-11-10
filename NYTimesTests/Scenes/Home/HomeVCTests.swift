//
//  HomeVCTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//

@testable import NYTimes
import XCTest

class HomeVCTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: HomeViewController!
    var window: UIWindow!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        sut = makeSUT()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func makeSUT() -> HomeViewController {
        let sut = UIStoryboard.homeViewController()!
        let spy = HomeBusinessLogicSpy()
        sut.interactor = spy
        sut.loadViewIfNeeded()
        return sut
    }
    
    // MARK: Test doubles
    
    class HomeBusinessLogicSpy: HomeBusinessLogic {
        var doGetArticleCalled = false
        
        func doGetArticles(request: Home.GetArticles.Request) {
            doGetArticleCalled = true
        }
    }
    
    // MARK: Tests
    
    func testShouldDoGetArticleWhenViewIsLoaded() {
        // Given
        let spy = HomeBusinessLogicSpy()
        sut.interactor = spy
        // When
        sut.viewDidLoad()
        // Then
        XCTAssertTrue(spy.doGetArticleCalled, "viewDidLoad() should ask the interactor to do get article")
    }
    
    func testDisplayArticleByViewdDay() {
        // Given
        let viewModelOneDay = Home.GetArticles.ViewModel(period: .oneDay, articles: [])
        let viewModel7Days = Home.GetArticles.ViewModel(period: .sevenDays, articles: [])
        let viewModel30Days = Home.GetArticles.ViewModel(period: .thirtyDays, articles: [])
        // When
        sut.displayArticles(viewModel: viewModelOneDay)
        sut.displayArticles(viewModel: viewModel7Days)
        sut.displayArticles(viewModel: viewModel30Days)
        // Then
        XCTAssertEqual(sut.viewed1Day.count, 0, "viewed1Day should be 0")
        XCTAssertEqual(sut.viewed7Days.count, 0, "viewed7Days should be 0")
        XCTAssertEqual(sut.viewed30Days.count, 0, "viewed30Days should be 0")
    }
    
    func testDisplayArticleViewOneDay() {
        // Given
        let collectionViewSpy = CollectionViewSpy(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewFlowLayout())
        sut.articleCollectionView = collectionViewSpy
        let articleViewedOneDayData = AppUtility.readLocalFile(forName: "OneDayArticles")
        let responseData = Home.GetArticles.Response.from(data: articleViewedOneDayData)
        let viewModel = Home.GetArticles.ViewModel(period: .oneDay, articles: responseData?.results)
        // When
        sut.displayArticles(viewModel: viewModel)
        // Then
        let waitExpectation = expectation(description: "Waiting")
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            XCTAssert(collectionViewSpy.reloadDataCalled, "Displaying fetched orders should reload collection view")
            waitExpectation.fulfill()
        }
        waitForExpectations(timeout: 2 + 0.5)
    }
    
    func testNumberOfSections() {
        // Given
        let collectionView = sut.articleCollectionView!
        // When
        let numberOfSections = sut.numberOfSections(in: collectionView)
        // Then
        XCTAssertEqual(numberOfSections, 3, "numberOfSections should be 3")
    }
    
    func testNumberOfRowInSection() {
        // Given
        let collectionView = sut.articleCollectionView!
        let articleViewedOneDayData = AppUtility.readLocalFile(forName: "OneDayArticles")
        let responseData = Home.GetArticles.Response.from(data: articleViewedOneDayData)
        sut.viewed1Day = responseData?.results ?? []
        // When
        let numberOfRows = sut.collectionView(collectionView, numberOfItemsInSection: 0)
        // Then
        XCTAssertEqual(numberOfRows, 1, "numberOfSections should be 20")
    }
    
    func testShouldConfigureCollectionCellToDisplayArticles() {
        // Given
        let collectionView = sut.articleCollectionView!
        let articleViewedOneDayData = AppUtility.readLocalFile(forName: "OneDayArticles")
        let responseData = Home.GetArticles.Response.from(data: articleViewedOneDayData)
        sut.viewed1Day = responseData?.results ?? []
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.collectionView(collectionView, cellForItemAt: indexPath) as! ArticleCell
        // Then
        XCTAssertEqual(cell.title.text, "Under Scrutiny Over Gaza, Israel Points to Civilian Toll of U.S. Wars", "article of first cell should Under Scrutiny Over Gaza, Israel Points to Civilian Toll of U.S. Wars")
    }
    
    func testShouldConfigureCollectionCellToDisplayHorizontalArticles() {
        // Given
        let collectionView = sut.articleCollectionView!
        let articleViewedOneDayData = AppUtility.readLocalFile(forName: "ThirtyDaysArticles")
        let responseData = Home.GetArticles.Response.from(data: articleViewedOneDayData)
        sut.viewed30Days = responseData?.results ?? []
        // When
        let indexPath = IndexPath(row: 0, section: 2)
        let cell = sut.collectionView(collectionView, cellForItemAt: indexPath) as! HorizontalArticleCell
        // Then
        XCTAssertEqual(cell.title.text, "Hamas gunmen surged into Israel in a highly organized and meticulously planned operation that suggested a deep understanding of Israel’s weaknesses. Here is how the attacks unfolded.", "article of first cell should Hamas gunmen surged into Israel in a highly organized and meticulously planned operation that suggested a deep understanding of Israel’s weaknesses. Here is how the attacks unfolded.")
    }
    
    func testRefreshControl() {
        // Given
        let spy = HomeBusinessLogicSpy()
        sut.interactor = spy
        // When
        sut.refreshControl.sendActions(for: .valueChanged)
        // Then
        XCTAssertTrue(spy.doGetArticleCalled, "refreshControl() should ask the interactor to do get article")
    }
}


class CollectionViewSpy: UICollectionView {
    // MARK: Method call expectations
    
    var reloadDataCalled = false
    
    // MARK: Spied methods
    
    override func reloadSections(_ sections: IndexSet) {
        reloadDataCalled = true
    }
    
    override func reloadData() {
        reloadDataCalled = true
    }
}
