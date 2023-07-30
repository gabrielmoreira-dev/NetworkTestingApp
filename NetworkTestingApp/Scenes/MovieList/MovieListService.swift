protocol MovieListServiceType {
    typealias Completion = (Result<[Movie], ApiError>) -> Void
    
    func fetchMovieList(completion: @escaping Completion)
}

final class MovieListService {
    private let httpClient: HttpClientType
    
    init(httpClient: HttpClientType = HttpClient()) {
        self.httpClient = httpClient
    }
}

extension MovieListService: MovieListServiceType {
    func fetchMovieList(completion: @escaping Completion) {
        let urlString = "http://example.com/api/movies"
        httpClient.get(urlString, completion: completion)
    }
}
