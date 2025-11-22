import FlutterMacOS
import AppKit

public class FilePickerPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "file_picker",
            binaryMessenger: registrar.messenger
        )
        let instance = FilePickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "pickFile":
            handlePickFile(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handlePickFile(call: FlutterMethodCall, result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            NSApp.activate(ignoringOtherApps: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.showFilePicker(call: call, result: result)
            }
        }
    }

    private func showFilePicker(call: FlutterMethodCall, result: @escaping FlutterResult) {
        let panel = NSOpenPanel()
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.allowsMultipleSelection = false
        panel.title = "Select File"
        panel.message = "Please select a backup file"
        panel.prompt = "Choose"

        var allowedFileTypes = ["json", "characterbook"]

        if let args = call.arguments as? [String: Any],
            let fileExtension = args["fileExtension"] as? String
        {
            print("Received file extensions: \(fileExtension)")

            let extensions =
                fileExtension
                .replacingOccurrences(of: ".", with: "")
                .components(separatedBy: CharacterSet(charactersIn: ",;"))
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }

            if !extensions.isEmpty {
                allowedFileTypes = extensions
            }
        }

        print("Setting allowed file types: \(allowedFileTypes)")
        panel.allowedFileTypes = allowedFileTypes

        let response = panel.runModal()

        if response == .OK, let url = panel.urls.first {
            print("User selected file: \(url.path)")
            result(url.path)
        } else {
            print("User cancelled file selection")
            result(nil)
        }
    }
}