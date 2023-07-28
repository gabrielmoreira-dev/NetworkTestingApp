import SwiftUI

final class MovieListFactory {
    static func make() -> some View {
        let httpClient = HttpClient<[Movie]>()
        let service = MovieListService(httpClient: httpClient)
        let viewModel = MovieListViewModel(service: service)
        let view = MovieListView(viewModel: viewModel)
        return view
    }
}
