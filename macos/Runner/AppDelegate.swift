import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    var flutterViewController: FlutterViewController?

    private var fileHandlerChannel: FlutterMethodChannel?
    private var pendingFile: [String: String]?

    override func applicationDidFinishLaunching(_ notification: Notification) {
        let mainWindow = self.mainFlutterWindow as? MainFlutterWindow
        self.flutterViewController = mainWindow?.contentViewController as? FlutterViewController

        if let controller = flutterViewController {
            fileHandlerChannel = FlutterMethodChannel(
                name: "file_handler",
                binaryMessenger: controller.engine.binaryMessenger
            )
            fileHandlerChannel?.setMethodCallHandler { [weak self] call, result in
                switch call.method {
                case "getOpenedFile":
                    if let file = self?.pendingFile {
                        result(file)
                        self?.pendingFile = nil
                    } else {
                        result(nil)
                    }
                default:
                    result(FlutterMethodNotImplemented)
                }
            }

            if let pending = pendingFile {
                fileHandlerChannel?.invokeMethod("onFileOpened", arguments: pending)
                pendingFile = nil
            }
        }

        setupMenuHandlers()

        super.applicationDidFinishLaunching(notification)
    }

    override func application(_ sender: NSApplication, openFile filename: String) -> Bool {
        let fileData: [String: String] = [
            "path": filename,
            "type": determineType(from: filename),
            "originalName": (filename as NSString).lastPathComponent,
        ]

        if let channel = fileHandlerChannel {
            channel.invokeMethod("onFileOpened", arguments: fileData)
        } else {
            pendingFile = fileData
        }
        return true
    }

    private func determineType(from path: String) -> String {
        let ext = (path as NSString).pathExtension.lowercased()
        switch ext {
        case "character", "json":
            return "character"
        case "race":
            return "race"
        case "chax":
            return "chax"
        default:
            return "unknown"
        }
    }

    func setupMenuHandlers() {
        if let mainMenu = NSApp.mainMenu,
            let appMenu = mainMenu.item(at: 0)?.submenu,
            let preferencesItem = appMenu.item(withTitle: "Preferences…")
        {
            preferencesItem.target = self
            preferencesItem.action = #selector(openPreferences(_:))
        }
    }

    @objc func openPreferences(_ sender: Any?) {
        let channel = FlutterMethodChannel(
            name: "characterbook/menu",
            binaryMessenger: flutterViewController!.engine.binaryMessenger
        )
        channel.invokeMethod("openSettings", arguments: nil)
    }

    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
