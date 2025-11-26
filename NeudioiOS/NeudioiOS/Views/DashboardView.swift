import SwiftUI

struct DashboardView: View {
    @EnvironmentObject private var viewModel: MainViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Connection: \(viewModel.connectionStatus)")
                    .font(.headline)

                HStack(spacing: 12) {
                    BandBarView(title: "Alpha", value: viewModel.bands.alpha)
                    BandBarView(title: "Beta", value: viewModel.bands.beta)
                    BandBarView(title: "Theta", value: viewModel.bands.theta)
                }

                Text("State: \(viewModel.state.rawValue.capitalized)")
                    .font(.title2)

                NavigationLink("Open Debug View") {
                    DebugView()
                }
            }
            .padding()
            .navigationTitle("Neudio Brain Music")
        }
    }
}

struct BandBarView: View {
    let title: String
    let value: Float

    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline)
            ProgressView(value: min(max(value, 0), 1))
                .progressViewStyle(.linear)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DashboardView().environmentObject(MainViewModel())
}
