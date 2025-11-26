import Foundation

final class BrainStateMachine {
    static let shared = BrainStateMachine()
    private init() {}

    func determineState(bands: BrainBandPower) -> BrainState {
        if bands.alpha > 0.8 { return .relaxed }

        let ratio = bands.beta / max(0.001, bands.theta)
        if ratio > 2.0 { return .focused }

        return .neutral
    }
}
