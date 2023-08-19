import SwiftUI

final class MovieListViewModel: ObservableObject {
    private let service: MovieListServiceType
    @Published var movies: [Movie] = []

    init(service: MovieListServiceType) {
        self.service = service
    }

    func getMovies() {
        service.fetchMovieList { [weak self] in
            switch $0 {
            case .success(let movies):
                self?.movies = movies
            case .failure:
                break
            }
        }
    }
}
