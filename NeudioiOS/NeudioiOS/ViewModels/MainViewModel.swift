import Combine
import Foundation

final class MainViewModel: ObservableObject {
    @Published var state: BrainState = .neutral
    @Published var bands: BrainBandPower = .init(delta: 0, theta: 0, alpha: 0, beta: 0)
    @Published var connectionStatus: String = "Disconnected"

    private var cancellables = Set<AnyCancellable>()
    private let bleManager = BLEManager.shared
    private let dsp = BrainDSP.shared
    private let stateMachine = BrainStateMachine.shared
    private let midi = MIDIHelper.shared

    init() {
        bleManager.delegate = self
        bleManager.$isConnected
            .sink { [weak self] connected in
                self?.connectionStatus = connected ? "Connected" : "Disconnected"
            }
            .store(in: &cancellables)

        bleManager.start()
    }
}

extension MainViewModel: BLEManagerDelegate {
    func didReceiveSamples(_ samples: [Float]) {
        DataLogger.shared.save(samples)
        bands = dsp.process(samples)
        state = stateMachine.determineState(bands: bands)

        let focusScore = bands.beta / max(0.001, bands.alpha)
        let midiValue: UInt8 = focusScore > 1.5 ? 127 : 50
        midi.send(value: midiValue)
    }
}
