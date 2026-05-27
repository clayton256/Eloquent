import AppIntents
import Foundation
import AppKit

// MARK: - App Shortcuts Provider
struct EloquentShortcuts: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor = .purple

    static var appShortcuts: [AppShortcut] {
        [
            AppShortcut(
                intent: SearchPassageIntent(),
                phrases: [
                    "Search with \\(.applicationName)",
                    "Search \\(.applicationName) for \\(.variable(\\.$query))",
                    "Find \\(.variable(\\.$query)) in \\(.applicationName)"
                ],
                shortTitle: "Search",
                systemImageName: "text.magnifyingglass"
            ),
            AppShortcut(
                intent: OpenPassageIntent(),
                phrases: [
                    "Open passage in \\(.applicationName)",
                    "Open \\(.variable(\\.$reference)) in \\(.applicationName)"
                ],
                shortTitle: "Open Passage",
                systemImageName: "book"
            )
        ]
    }
}

// MARK: - Search Intent
struct SearchPassageIntent: AppIntent {
    static var title: LocalizedStringResource = "Search Passage"
    static var description = IntentDescription(
        "Searches scripture text for a query in an optional version, returning a text result."
    )

    @Parameter(title: "Query", requestValueDialog: "What would you like to search for?")
    var query: String

    @Parameter(title: "Version", requestValueDialog: "Which version would you like to use?")
    var version: String?

    static var parameterSummary: some ParameterSummary {
        Summary("Search \(\.$query) in \(\.$version)")
    }

    static var openAppWhenRun: Bool = false

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let resolvedVersion = version?.trimmingCharacters(in: .whitespacesAndNewlines)
        let usedVersion = (resolvedVersion?.isEmpty == false) ? resolvedVersion! : nil

        // Bridge to Objective-C search manager (synchronous stub for now).
        let text = SearchManager.shared().searchFor(query, inVersion: usedVersion, error: nil) ?? ""
        return .result(value: text)
    }
}

// MARK: - Open Passage Intent
struct OpenPassageIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Passage"
    static var description = IntentDescription("Opens a passage in the app and returns a short confirmation string.")

    @Parameter(title: "Reference", requestValueDialog: "Which passage?")
    var reference: String

    @Parameter(title: "Version")
    var version: String?

    static var openAppWhenRun: Bool = true

    static var parameterSummary: some ParameterSummary {
        Summary("Open \(\.$reference) in \(\.$version)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        // Bridge to Objective-C to open/navigate the UI. For now, call a stub.
        SearchManager.shared().openPassage(reference, version: version)
        let suffix = (version?.isEmpty == false) ? " in \(version!)" : ""
        return .result(value: "Opened \(reference)\(suffix)")
    }
}
