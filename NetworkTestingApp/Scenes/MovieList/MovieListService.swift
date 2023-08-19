import Foundation

protocol MovieListServiceType {
    typealias Completion = (Result<[Movie], ApiError>) -> Void
    
    func fetchMovieList(completion: @escaping Completion)
}

final class MovieListService {
    private let httpClient: HttpClientType
    private let mainQueue: DispatchQueueType
    
    init(httpClient: HttpClientType = HttpClient(), mainQueue: DispatchQueueType = DispatchQueue.main) {
        self.httpClient = httpClient
        self.mainQueue = mainQueue
    }
}

extension MovieListService: MovieListServiceType {
    func fetchMovieList(completion: @escaping Completion) {
        let url = "https://test-example.com/api/movies"
        httpClient.get(url) { [weak self] result in
            self?.mainQueue.async {
                completion(result)
            }
        }
    }
}
