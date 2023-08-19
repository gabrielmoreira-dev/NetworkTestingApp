@testable import NetworkTestingApp
import XCTest

final class MovieListServiceTest: XCTestCase {
    private let httpClient = HttpClientSpy()
    private let mainQueue = DispatchQueueFake()
    private lazy var sut = MovieListService(httpClient: httpClient, mainQueue: mainQueue)
    private let movieList: [Movie] = [Movie(id: 0, title: "A title", imageURL: "http://example.com")]

    func test_whenFetchMovieListCalled_shouldPassCorrectURL() {
        sut.fetchMovieList { _ in }

        XCTAssertEqual(httpClient.receivedURLs, ["https://test-example.com/api/movies"])
    }

    func test_whenFetchMovieListWithSuccess_shouldPassMovieList() {
        let expectation = XCTestExpectation()
        var receivedResult: Result<[Movie], ApiError>?
        httpClient.result = .success(movieList)

        sut.fetchMovieList { result in
            receivedResult = result
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 3)
        XCTAssertEqual(receivedResult, .success(movieList))
    }
}

private final class HttpClientSpy: HttpClientType {
    private(set) var receivedURLs: [String] = []
    var result: Result<[Movie], ApiError> = .failure(.serverError)

    func get<T: Decodable>(_ urlString: String, completion: @escaping Completion<T>) {
        guard let result = result as? Result<T, ApiError> else { return }
        receivedURLs.append(urlString)
        completion(result)
    }
}

private final class DispatchQueueFake: DispatchQueueType {
    func async(execute work: @escaping @convention(block) () -> Void) {
        work()
    }
}
