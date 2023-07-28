@testable import NetworkTestingApp
import XCTest

final class HttpClientTest: XCTestCase {
    private let urlString = "http://example.com"
    private let session = URLSessionSpy()
    private lazy var sut = HttpClient<String>(session: session)
    
    func test_whenGetRequest_shouldCatchURL() {
        sut.get(urlString) { _ in }
        
        XCTAssertEqual(session.receivedURLs.first?.absoluteString, urlString)
    }
    
    func test_whenGetRequest_showCallResume() {
        let dataTask = URLSessionDataTaskSpy()
        session.nextDataTask = dataTask
        
        sut.get(urlString) { _ in }
        
        XCTAssertEqual(dataTask.resumeCount, 1)
    }
    
    func test_whenGetRequestWithInvalidURL_shouldReturnError() {
        let expectation = XCTestExpectation()
        let invalidURL = String()
        var error: ApiError?
        
        sut.get(invalidURL) { result in
            if case let .failure(value) = result {
                error = value
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
        XCTAssertEqual(error, .invalidURL)
    }
    
    func test_whenGetRequestWithError_shouldReturnError() {
        let expectation = XCTestExpectation()
        var error: ApiError?
        session.error = NSError()
        
        sut.get(urlString) { result in
            if case let .failure(value) = result {
                error = value
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
        XCTAssertEqual(error, .serverError)
    }
    
    func test_whenGetRequestWithEmptyData_shouldReturnError() {
        let expectation = XCTestExpectation()
        var error: ApiError?
        
        sut.get(urlString) { result in
            if case let .failure(value) = result {
                error = value
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
        XCTAssertEqual(error, .emptyData)
    }
    
    func test_whenGetRequestWithInvalidData_shouldReturnError() {
        let expectation = XCTestExpectation()
        var error: ApiError?
        session.data = Data()
        
        sut.get(urlString) { result in
            if case let .failure(value) = result {
                error = value
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation])
        XCTAssertEqual(error, .decodeError)
    }
}

private final class URLSessionSpy: URLSessionType {
    private(set) var receivedURLs: [URL] = []
    var nextDataTask = URLSessionDataTaskSpy()
    var data: Data?
    var error: Error?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskType {
        if let url = request.url {
            receivedURLs.append(url)
        }
        completionHandler(data, nil, error)
        return nextDataTask
    }
}

private final class URLSessionDataTaskSpy: URLSessionDataTaskType {
    private(set) var resumeCount = 0
    
    func resume() {
        resumeCount += 1
    }
}
