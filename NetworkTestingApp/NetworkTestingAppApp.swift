import SwiftUI

@main
struct NetworkTestingAppApp: App {
    var body: some Scene {
        WindowGroup {
            MovieListFactory.make()
        }
    }
}
