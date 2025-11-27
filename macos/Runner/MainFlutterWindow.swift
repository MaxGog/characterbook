import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.titleVisibility = .hidden

    FilePickerPlugin.register(with: flutterViewController.registrar(forPlugin: "FilePickerPlugin"))

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
  }
}