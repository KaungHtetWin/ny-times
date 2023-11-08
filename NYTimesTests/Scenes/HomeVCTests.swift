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
    window = UIWindow()
    setupHomeVC()
  }
  
  override func tearDown() {
    window = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupHomeVC() {
      sut = UIStoryboard.homeViewController()
  }
  
  func loadView() {
    window.addSubview(sut.view)
    RunLoop.current.run(until: Date())
  }
  
  // MARK: Test doubles
  
  class HomeBusinessLogicSpy: HomeBusinessLogic {
    var doSomethingCalled = false
    
    func doGetHome(request: Home.GetArticles.Request) {
      doSomethingCalled = true
    }
  }
  
  // MARK: Tests
  
  func testShouldDoHomeWhenViewIsLoaded() {
    // Given
    let spy = HomeBusinessLogicSpy()
    sut.interactor = spy
    
    // When
    loadView()
    
    // Then
    XCTAssertTrue(spy.doSomethingCalled, "viewDidLoad() should ask the interactor to do something")
  }
  
  func testDisplayHome() {
    // Given
      let viewModel = Home.GetArticles.ViewModel(articles: [Article]())
    
    // When
    loadView()
    sut.displayHome(viewModel: viewModel)
    
    // Then
    //XCTAssertEqual(sut.nameTextField.text, "", "displaySomething(viewModel:) should update the name text field")
  }
}
