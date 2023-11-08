//
//  HomeWorkerTests.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 8/11/23.
//
//
import XCTest
@testable import NYTimes


class HomeWorkerTests: XCTestCase {
    // MARK: Subject under test
    
    var sut: HomeWorker!
    
    // MARK: Test lifecycle
    
    override func setUp() {
        super.setUp()
        setupHomeWorker()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: Test setup
    
    func setupHomeWorker() {
        sut = HomeWorker()
        sut.apiManager = MockAPIManager()
    }
    
    // MARK: Tests
    
    func testGetArticleOneDayPeriod() {
        // Given
        let successExpectation = expectation(description: "get Article one day period should response data")
        let request = Home.GetArticles.Request()
        // When
        sut.doGetArticles(requestData: request, completed: { (JSONObject, error) in
            // Then
            XCTAssertNotNil(JSONObject, "doGetArticles should response data")
            successExpectation.fulfill()
        })
        wait(for: [successExpectation], timeout: 2)
    }
    
    func testGetArticle7DayPeriod() {
        // Given
        let successExpectation = expectation(description: "get Article 7 day period should response data")
        let request = Home.GetArticles.Request(period: .sevenDays)
        // When
        sut.doGetArticles(requestData: request, completed: { (JSONObject, error) in
            // Then
            XCTAssertNotNil(JSONObject, "doGetArticles should response data")
            successExpectation.fulfill()
        })
        wait(for: [successExpectation], timeout: 2)
    }
    
    func testGetArticle30DayPeriod() {
        // Given
        let successExpectation = expectation(description: "get Article 30 day period should response data")
        let request = Home.GetArticles.Request(period: .thirtyDays)
        // When
        sut.doGetArticles(requestData: request, completed: { (JSONObject, error) in
            // Then
            XCTAssertNotNil(JSONObject, "doGetArticles should response data")
            successExpectation.fulfill()
        })
        wait(for: [successExpectation], timeout: 2)
    }
}

// MARK: Test doubles

class MockAPIManager: APIManagerLogic {
    func sendJSONRequest(endpoint: Endpoint, completion: @escaping (ResponseDataCompletionHandler)) {
        if endpoint.path == "viewed/1.json" {
            completion(AppUtility.readLocalFile(forName: "OneDayArticles"), nil)
        } else if endpoint.path == "viewed/7.json" {
            completion(AppUtility.readLocalFile(forName: "SevenDayArticles"), nil)
        } else if endpoint.path == "viewed/30.json" {
            completion(AppUtility.readLocalFile(forName: "ThirtyDaysArticles"), nil)
        }
    }
}
