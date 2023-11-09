//
//  SearchArticlesVCTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

@testable import NYTimes
import XCTest

class SearchArticlesVCTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: SearchArticlesViewController!
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
    func makeSUT() -> SearchArticlesViewController {
        let sut = UIStoryboard.searchArticlesViewController()!
        let spy = SearchArticlesBusinessLogicSpy()
        sut.interactor = spy
        sut.loadViewIfNeeded()
        return sut
    }
    // MARK: Test doubles
    
    class SearchArticlesBusinessLogicSpy: SearchArticlesBusinessLogic {
        var doSearchArticleCalled = false
        
        func doGetSearchArticles(request: SearchArticles.Search.Request) {
            doSearchArticleCalled = true
        }
    }
    
    // MARK: Tests
    
    func testShouldDoSearchArticlesWhenViewIsLoaded() {
        // Given
        let spy = SearchArticlesBusinessLogicSpy()
        sut.interactor = spy
        
        // When
        sut.viewDidLoad()
        
        // Then
        XCTAssertTrue(spy.doSearchArticleCalled, "viewDidLoad() should ask the interactor to do something")
    }
    
    func testSearchDisplayArticle() {
        // Given
        let collectionViewSpy = CollectionViewSpy(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: UICollectionViewFlowLayout())
        sut.articleCollectionView = collectionViewSpy
        let articleSearchData = AppUtility.readLocalFile(forName: "SearchArticles")
        let responseData = SearchArticles.Search.Response.from(data: articleSearchData)
        let viewModel = SearchArticles.Search.ViewModel(docs: responseData?.searchResponse?.docs ?? [])
        // When
        sut.displaySearchArticles(viewModel: viewModel)
        // Then
        let waitExpectation = expectation(description: "Waiting")
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when) {
            XCTAssert(collectionViewSpy.reloadDataCalled, "Displaying search article should reload collection view")
            waitExpectation.fulfill()
        }
        waitForExpectations(timeout: 2 + 0.5)
    }
    
    func testNumberOfRowInSection() {
        // Given
        let collectionView = sut.articleCollectionView!
        let articleSearchData = AppUtility.readLocalFile(forName: "SearchArticles")
        let responseData = SearchArticles.Search.Response.from(data: articleSearchData)
        sut.searchArticles = responseData?.searchResponse?.docs ?? []
        // When
        let numberOfRows = sut.collectionView(collectionView, numberOfItemsInSection: 0)
        // Then
        XCTAssertEqual(numberOfRows, 10, "numberOfSections should be 20")
    }
    
    func testShouldConfigureCollectionCellToDisplaySearchArticles() {
        // Given
        let collectionView = sut.articleCollectionView!
        let articleSearchData = AppUtility.readLocalFile(forName: "SearchArticles")
        let responseData = SearchArticles.Search.Response.from(data: articleSearchData)
        sut.searchArticles = responseData?.searchResponse?.docs ?? []
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.collectionView(collectionView, cellForItemAt: indexPath) as! HorizontalArticleCell
        // Then
        XCTAssertEqual(cell.title.text,
                       "Eleven of the dead were under 16, and 56 people were wounded, said the Kachin Independence Army, which controls the area.",
                       "first article title should be Eleven of the dead were under 16, and 56 people were wounded, said the Kachin Independence Army, which controls the area.")
    }
    
    func testSearchBarChangeText() {
        // Given
        let spy = SearchArticlesBusinessLogicSpy()
        sut.interactor = spy
        // When
        sut.articleSearchBar.text = "Myanma"
        let isValid = sut.searchBar(sut.articleSearchBar,
                          shouldChangeTextIn: NSRange(location: 0, length: 1),
                          replacementText: "r")
        // Then
        let waitExpectation = expectation(description: "Waiting")
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            XCTAssertTrue(isValid, "searchBar data should return true")
            XCTAssertTrue(spy.doSearchArticleCalled, "searchBar() should ask the interactor to do get search article")
            waitExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.5)
    }
    
    func testSearchBarEmpty() {
        // Given
        let spy = SearchArticlesBusinessLogicSpy()
        sut.interactor = spy
        // When
        sut.articleSearchBar.text = ""
        let isValid = sut.searchBar(sut.articleSearchBar, shouldChangeTextIn: NSRange(location: 0, length: 0), replacementText: "")
        // Then
        let waitExpectation = expectation(description: "Waiting")
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            XCTAssertTrue(isValid, "searchBar data should return true")
            XCTAssertTrue(spy.doSearchArticleCalled, "searchBar() should ask the interactor to do get search article")
            waitExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.5)
    }
}
