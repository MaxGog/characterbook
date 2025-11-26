import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    override func applicationWillFinishLaunching(_ notification: Notification) {
        if let menu = super.applicationMenu {
            NSApplication.shared.mainMenu = menu
        }
        super.applicationWillFinishLaunching(notification)
    }

    override func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.activate(ignoringOtherApps: true)
        
        if let window = self.mainFlutterWindow {
            window.makeKeyAndOrderFront(nil)
            window.center()
            window.orderFrontRegardless()
        }

        super.applicationDidFinishLaunching(notification)
    }

    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    @IBAction func showAboutPanel(_ sender: Any?) {
        NSApp.orderFrontStandardAboutPanel(sender)
    }

    @IBAction func openFile(_ sender: Any?) {
        let dialog = NSOpenPanel()
        dialog.title = "Choose a file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.allowsMultipleSelection = false
        dialog.canChooseDirectories = false

        if dialog.runModal() == .OK {
            if let result = dialog.url {
                self.sendFilePathToFlutter(path: result.path)
            }
        }
    }

    private func sendFilePathToFlutter(path: String) {
        guard let controller = mainFlutterWindow?.contentViewController as? FlutterViewController else { return }
        
        let channel = FlutterMethodChannel(name: "native_channel", binaryMessenger: controller.engine.binaryMessenger)
        channel.invokeMethod("fileSelected", arguments: path)
    }
}