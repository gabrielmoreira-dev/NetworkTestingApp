@testable import NetworkTestingApp
import XCTest

final class HttpClientTest: XCTestCase {
    private let urlString = "http://example.com"
    private let session = URLSessionSpy()
    private lazy var sut = HttpClient<String>(session: session)
    
    func test_getRequest_withURL() {
        sut.get(urlString) { _ in }
        
        XCTAssertEqual(session.receivedURLs.first?.absoluteString, urlString)
    }
    
    func test_getRequest_ResumeIsCalled() {
        let dataTask = URLSessionDataTaskSpy()
        session.nextDataTask = dataTask
        
        sut.get(urlString) { _ in }
        
        XCTAssertEqual(dataTask.resumeCount, 1)
    }
}

private final class URLSessionSpy: URLSessionType {
    private(set) var receivedURLs: [URL] = []
    var nextDataTask = URLSessionDataTaskSpy()
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskType {
        if let url = request.url {
            receivedURLs.append(url)
        }
        return nextDataTask
    }
}

private final class URLSessionDataTaskSpy: URLSessionDataTaskType {
    private(set) var resumeCount = 0
    
    func resume() {
        resumeCount += 1
    }
}
