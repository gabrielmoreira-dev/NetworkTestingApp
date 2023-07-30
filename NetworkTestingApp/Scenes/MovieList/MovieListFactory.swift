import SwiftUI

final class MovieListFactory {
    static func make() -> some View {
        let service = MovieListService()
        let viewModel = MovieListViewModel(service: service)
        let view = MovieListView(viewModel: viewModel)
        return view
    }
}
