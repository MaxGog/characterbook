import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    override func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.activate(ignoringOtherApps: true)

        if let window = NSApplication.shared.windows.first {
            window.makeKeyAndOrderFront(nil)
        }

        super.applicationDidFinishLaunching(notification)
    }

    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    @IBAction func showAboutPanel(_ sender: Any?) {
        NSApp.orderFrontStandardAboutPanel(sender)
    }
}