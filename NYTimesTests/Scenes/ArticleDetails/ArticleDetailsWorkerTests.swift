//
//  ArticleDetailsWorkerTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//
//

@testable import NYTimes
import XCTest

class ArticleDetailsWorkerTests: XCTestCase {
  // MARK: Subject under test
  
  var sut: ArticleDetailsWorker!
  
  // MARK: Test lifecycle
  
  override func setUp() {
    super.setUp()
    setupArticleDetailsWorker()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupArticleDetailsWorker() {
    sut = ArticleDetailsWorker()
  }
  
  // MARK: Test doubles
  
  // MARK: Tests
  
  func testSomething() {
    // Given
    
    // When
    
    // Then
  }
}
