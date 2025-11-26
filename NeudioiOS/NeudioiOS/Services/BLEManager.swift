import Combine
import CoreBluetooth
import Foundation

protocol BLEManagerDelegate: AnyObject {
    func didReceiveSamples(_ samples: [Float])
}

final class BLEManager: NSObject, ObservableObject {
    static let shared = BLEManager()

    @Published var isConnected: Bool = false
    weak var delegate: BLEManagerDelegate?

    private var centralManager: CBCentralManager?
    private var peripheral: CBPeripheral?

    func start() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
}

extension BLEManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            // TODO: scan for your peripheral
            break
        default:
            isConnected = false
        }
    }
}

extension BLEManager: CBPeripheralDelegate {}
