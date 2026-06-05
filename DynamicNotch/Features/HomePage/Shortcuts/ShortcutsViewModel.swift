//
//  ShortcutsViewModel.swift
//  DynamicNotch
//

import Foundation
import Combine

@MainActor
final class ShortcutsViewModel: ObservableObject {
    @Published var shortcuts: [String] = []
    @Published var isFetching: Bool = false
    @Published var errorMessage: String? = nil
    
    init() {
        fetchShortcuts()
    }
    
    func fetchShortcuts() {
        guard !isFetching else { return }
        isFetching = true
        errorMessage = nil
        
        Task.detached {
            let process = Process()
            let pipe = Pipe()
            let errorPipe = Pipe()
            
            process.executableURL = URL(fileURLWithPath: "/usr/bin/shortcuts")
            process.arguments = ["list"]
            process.standardOutput = pipe
            process.standardError = errorPipe
            
            do {
                try process.run()
                process.waitUntilExit()
                
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                if let output = String(data: data, encoding: .utf8) {
                    let list = output.components(separatedBy: .newlines)
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                        .filter { !$0.isEmpty }
                    
                    await MainActor.run {
                        self.shortcuts = list
                        self.isFetching = false
                    }
                } else {
                    await MainActor.run {
                        self.errorMessage = "Failed to parse shortcuts output"
                        self.isFetching = false
                    }
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.isFetching = false
                }
            }
        }
    }
    
    func runShortcut(name: String) {
        Task.detached {
            let process = Process()
            process.executableURL = URL(fileURLWithPath: "/usr/bin/shortcuts")
            process.arguments = ["run", name]
            try? process.run()
        }
    }
}
