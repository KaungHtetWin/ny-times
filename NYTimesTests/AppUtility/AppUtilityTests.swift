//
//  AppUtilityTests.swift
//  NYTimesTests
//
//  Created by Kaung Htet Win on 9/11/23.
//

import XCTest
@testable import NYTimes

final class AppUtilityTests: XCTestCase {
    let label = UILabel()
    override func setUp() {
        super.setUp()
        
    }
    
    func testWhenValidFileNamePassShouldReturnData() {
        // Given
        let fileName = "ErrorArticles"
        // When
        let fileData = AppUtility.readLocalFile(forName: fileName)
        //Then
        XCTAssertNotNil(fileData, "Should return data")
    }
    
    func testWhenInvalidFileNamePassShouldReturnNil() {
        // Given
        let fileName = "ErrorArticles1"
        // When
        let fileData = AppUtility.readLocalFile(forName: fileName)
        //Then
        XCTAssertNil(fileData, "Should return empty data")
    }
}
