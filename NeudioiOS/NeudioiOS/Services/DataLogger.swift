import Foundation

final class DataLogger {
    static let shared = DataLogger()
    private let fileManager = FileManager.default
    private let directoryURL: URL

    private init() {
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        directoryURL = documents.appendingPathComponent("EEGLogs", isDirectory: true)
        try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
    }

    func save(_ samples: [Float]) {
        let filename = Date().formatted(date: .numeric, time: .standard).replacingOccurrences(of: "/", with: "-")
        let fileURL = directoryURL.appendingPathComponent("log-\(filename).csv")
        let line = samples.map(String.init).joined(separator: ",") + "\n"
        if let data = line.data(using: .utf8) {
            if fileManager.fileExists(atPath: fileURL.path) {
                if let handle = try? FileHandle(forWritingTo: fileURL) {
                    handle.seekToEndOfFile()
                    handle.write(data)
                    try? handle.close()
                }
            } else {
                try? data.write(to: fileURL)
            }
        }
    }
}
