@testable import NetworkTestingApp
import XCTest

final class MovieListServiceTest: XCTestCase {
    private let httpClient = HttpClientSpy()
    private lazy var sut = MovieListService(httpClient: httpClient)
    private let movieList: [Movie] = [Movie(title: "A title", imageURL: "http://example.com")]
    
    func test_whenFetchMovieListCalled_shouldPassCorrectURL() {
        sut.fetchMovieList { _ in }
        
        XCTAssertEqual(httpClient.receivedURLs, ["http://example.com/api/movies"])
    }
    
    func test_whenFetchMovieListWithSuccess_shouldPassMovieList() {
        let expectation = XCTestExpectation()
        var receivedResult: Result<[Movie], ApiError>?
        httpClient.result = .success(movieList)
        
        sut.fetchMovieList { result in
            receivedResult = result
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 0.5)
        XCTAssertEqual(receivedResult, .success(movieList))
    }
}

private final class HttpClientSpy: HttpClientType {
    typealias T = [Movie]
    private(set) var receivedURLs: [String] = []
    var result: Result<[Movie], ApiError> = .failure(.serverError)
    
    func get(_ urlString: String, completion: @escaping Completion) {
        receivedURLs.append(urlString)
        completion(result)
    }
}
