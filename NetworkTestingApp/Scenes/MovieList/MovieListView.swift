import SwiftUI

struct MovieListView: View {
    @ObservedObject private var viewModel: MovieListViewModel

    var body: some View {
        List(viewModel.movies) {
            Text($0.title)
        }
        .navigationTitle(Text("Movies"))
        .onAppear {
            viewModel.getMovies()
        }
    }

    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
    }
}
