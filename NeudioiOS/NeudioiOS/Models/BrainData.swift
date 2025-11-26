import Foundation

enum BrainState: String, CaseIterable {
    case relaxed
    case focused
    case flow
    case stressed
    case neutral
}

struct BrainBandPower {
    let delta: Float
    let theta: Float
    let alpha: Float
    let beta: Float
}
