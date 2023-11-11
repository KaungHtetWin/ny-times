//
//  APIManagerTests.swift
//  NYTimesTests
//
//  Created by Kaung Htet Win on 8/11/23.
//

import XCTest
@testable import NYTimes

final class APIManagerTests: XCTestCase {
    
    var sut: APIManager!
    
    override func setUp() {
        sut = APIManager()
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func testSendRequestShouldResponseData() {
        //Given
        URLProtocolMock.testURLs = [
            "https://mock.codes/200": Data("{\"statusCode\":200,\"description\":\"OK\"}".utf8),
        ]
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        sut = APIManager(configuration: configuration)
        let invalidExpectation = expectation(description: "send request should response data")
        //When
        sut.sendJSONRequest(endpoint: MockEndpointCases.MockSuccess, completion: {(data, error) in
            //Then
            XCTAssertNil(error)
            XCTAssertNotNil(data)
            invalidExpectation.fulfill()
        })

        wait(for: [invalidExpectation], timeout: 5)
    }
    
    func testSendRequestShouldResponseError() {
        //Given
        URLProtocolMock.testURLs = [
            "https://mock.codes/500": Data(),
        ]
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        sut = APIManager(configuration: configuration)
        let failExpectation = expectation(description: "send request should response error")
        // When
        sut.sendJSONRequest(endpoint: MockEndpointCases.MockFail, completion: {(data, error) in
            //Then
            XCTAssertNotNil(error)
            XCTAssertNil(data)
            failExpectation.fulfill()
        })
        
        wait(for: [failExpectation], timeout: 5)
    }
    
    func testSendRequestShouldResponseEmpty() {
        //Given
        URLProtocolMock.testURLs = [
            "": Data(),
        ]
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [URLProtocolMock.self]
        sut = APIManager(configuration: configuration)
        let throwExpectation = expectation(description: "send request should reponse url not found")
        // When
        sut.sendJSONRequest(endpoint: MockEndpointCases.MockInvalid, completion: {(data, error) in
            //Then
            XCTAssertEqual(error?.localizedDescription, APIError.URLNotFound.localizedDescription)
            XCTAssertNil(data)
            throwExpectation.fulfill()
        })
        
        wait(for: [throwExpectation], timeout: 5)
    }
}

enum MockEndpointCases: Endpoint {
    case MockSuccess
    case MockFail
    case MockInvalid
    
    var httpMethod: String {
        switch self {
        default:
            return "POST"
        }
    }
    
    var baseURLString: String {
        switch self {
        case .MockInvalid:
            return ""
        default:
            return "https://mock.codes/"
        }
    }
    
    var path: String {
        switch self {
        case .MockSuccess:
            return "200"
        case .MockFail:
            return "500"
        case .MockInvalid:
            return ""
        }
    }
    
    var headers: [String: String]? {
        switch self {
        default:
            return [:]
        }
    }
    
    var body: Data? {
        switch self {
        default:
            return nil
        }
    }
    
}

class URLProtocolMock: URLProtocol {
    // this dictionary maps URLs to test data
    static var testURLs = [String: Data]()
    
    // say we want to handle all types of request
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    // ignore this method; just send back what we were given
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        // if we have a valid URL…
        if let url = request.url?.absoluteString {
            // …and if we have test data for that URL…
            if let data = URLProtocolMock.testURLs[url] {
                // …load it immediately.
                if url == "https://mock.codes/500" {
                    self.client?.urlProtocol(self, didFailWithError: APIError.ServerError)
                } else if !url.isEmpty {
                    self.client?.urlProtocol(self, didLoad: data)
                }
            }
        }
        
        // mark that we've finished
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    // this method is required but doesn't need to do anything
    override func stopLoading() { }
}


class MockAPIManager: APIManagerLogic {
    func sendJSONRequest(endpoint: Endpoint, completion: @escaping (ResponseDataCompletionHandler)) {
        if endpoint.path.contains("viewed/1.json") {
            completion(AppUtility.readLocalFile(forName: "OneDayArticles"), nil)
        } else if endpoint.path.contains("viewed/7.json") {
            completion(AppUtility.readLocalFile(forName: "SevenDayArticles"), nil)
        } else if endpoint.path.contains("viewed/30.json") {
            completion(AppUtility.readLocalFile(forName: "ThirtyDaysArticles"), nil)
        } else if endpoint.path.contains("articlesearch.json") {
            completion(AppUtility.readLocalFile(forName: "SearchArticles"), nil)
        }
    }
}
