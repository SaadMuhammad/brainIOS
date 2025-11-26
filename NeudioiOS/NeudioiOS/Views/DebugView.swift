import SwiftUI

struct DebugView: View {
    @EnvironmentObject private var viewModel: MainViewModel

    var body: some View {
        List {
            Section("Band Power") {
                Text("Delta: \(viewModel.bands.delta, specifier: "%.3f")")
                Text("Theta: \(viewModel.bands.theta, specifier: "%.3f")")
                Text("Alpha: \(viewModel.bands.alpha, specifier: "%.3f")")
                Text("Beta: \(viewModel.bands.beta, specifier: "%.3f")")
            }

            Section("State") {
                Text(viewModel.state.rawValue.capitalized)
            }
        }
        .navigationTitle("Debug")
    }
}

#Preview {
    DebugView().environmentObject(MainViewModel())
}
