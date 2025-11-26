import CoreMIDI
import Foundation

final class MIDIHelper {
    static let shared = MIDIHelper()
    private var client = MIDIClientRef()
    private var source = MIDIEndpointRef()

    private init() {
        MIDIClientCreate("NeudioClient" as CFString, nil, nil, &client)
        MIDISourceCreate(client, "NeudioSource" as CFString, &source)
    }

    func send(value: UInt8) {
        // Placeholder MIDI CC message
        var packet = MIDIPacket()
        packet.timeStamp = 0
        packet.length = 3
        packet.data.0 = 0xB0 // Control change on channel 1
        packet.data.1 = 1    // CC #1 (mod wheel)
        packet.data.2 = value

        var packetList = MIDIPacketList(numPackets: 1, packet: packet)
        MIDIReceived(source, &packetList)
    }
}
