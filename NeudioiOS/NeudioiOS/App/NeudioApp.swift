import SwiftUI

@main
struct NeudioApp: App {
    @StateObject private var viewModel = MainViewModel()

    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(viewModel)
        }
    }
}
