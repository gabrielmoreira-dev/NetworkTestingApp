protocol MovieListServiceType {
    typealias Completion = (Result<[Movie], ApiError>) -> Void
    
    func fetchMovieList(completion: @escaping Completion)
}

final class MovieListService {
    private let httpClient: any HttpClientType<[Movie]>
    
    init(httpClient: some HttpClientType<[Movie]>) {
        self.httpClient = httpClient
    }
}

extension MovieListService: MovieListServiceType {
    func fetchMovieList(completion: @escaping Completion) {
        let urlString = "http://example.com/api/movies"
        httpClient.get(urlString, completion: completion)
    }
}
