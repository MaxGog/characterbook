import Flutter
import UIKit
import MobileCoreServices

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {

    private let CHANNEL = "file_picker"
    private let FILE_HANDLE_CHANNEL = "file_handler"

    private var pendingFileUrl: URL?
    private var result: FlutterResult?


    func didInitializeImplicitFlutterEngine(
        _ engineBridge: FlutterImplicitEngineBridge
    ) {
        GeneratedPluginRegistrant.register(
            with: engineBridge.pluginRegistry
        )

        let messenger = engineBridge.applicationRegistrar.messenger()

        let filePickerChannel = FlutterMethodChannel(
            name: CHANNEL,
            binaryMessenger: messenger
        )

        filePickerChannel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else {
                result(
                    FlutterError(
                        code: "APP_DELEGATE_DEALLOCATED",
                        message: "AppDelegate is no longer available",
                        details: nil
                    )
                )
                return
            }

            switch call.method {
            case "pickFile":
                self.result = result

                guard let controller = self.flutterViewController else {
                    result(
                        FlutterError(
                            code: "NO_VIEW_CONTROLLER",
                            message: "FlutterViewController is not available",
                            details: nil
                        )
                    )

                    self.result = nil
                    return
                }

                self.openFilePicker(controller: controller)

            default:
                result(FlutterMethodNotImplemented)
            }
        }

        let fileHandlerChannel = FlutterMethodChannel(
            name: FILE_HANDLE_CHANNEL,
            binaryMessenger: messenger
        )

        fileHandlerChannel.setMethodCallHandler { [weak self] call, result in
            guard let self = self else {
                result(
                    FlutterError(
                        code: "APP_DELEGATE_DEALLOCATED",
                        message: "AppDelegate is no longer available",
                        details: nil
                    )
                )
                return
            }

            switch call.method {
            case "getOpenedFile":
                guard let fileUrl = self.pendingFileUrl else {
                    result(nil)
                    return
                }

                self.processFile(
                    fileUrl: fileUrl,
                    result: result,
                    messenger: messenger
                )

                self.pendingFileUrl = nil

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private var flutterViewController: FlutterViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: {
                $0.activationState != .unattached
            }) else {
            return nil
        }

        return windowScene.windows
            .compactMap {
                $0.rootViewController as? FlutterViewController
            }
            .first
    }

    private func openFilePicker(
        controller: FlutterViewController
    ) {
        let documentPicker = UIDocumentPickerViewController(
            documentTypes: [
                String(kUTTypeData),
                String(kUTTypeContent),
                String(kUTTypeItem)
            ],
            in: .import
        )

        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet

        controller.present(
            documentPicker,
            animated: true
        )
    }

    func handleFileUrl(
        url: URL,
        messenger: FlutterBinaryMessenger
    ) {
        pendingFileUrl = url

        let fileType = determineFileType(url: url)

        guard fileType != "unknown" else {
            return
        }

        let fileHandlerChannel = FlutterMethodChannel(
            name: FILE_HANDLE_CHANNEL,
            binaryMessenger: messenger
        )

        fileHandlerChannel.invokeMethod(
            "showImportDialog",
            arguments: [
                "uri": url.absoluteString,
                "type": fileType
            ]
        )
    }

    private func determineFileType(url: URL) -> String {
        let path = url.absoluteString.lowercased()
        let fileName = url.lastPathComponent.lowercased()

        if path.contains(".character")
            || fileName.hasSuffix(".character") {
            return "character"

        } else if path.contains(".race")
            || fileName.hasSuffix(".race") {
            return "race"

        } else if path.contains(".chax")
            || fileName.hasSuffix(".chax") {
            return "chax"

        } else if path.contains(".note")
            || fileName.hasSuffix(".note") {
            return "note"

        } else if path.contains(".characterbook")
            || fileName.hasSuffix(".characterbook") {
            return "characterbook"

        } else {
            return "unknown"
        }
    }

    private func processFile(
        fileUrl: URL,
        result: @escaping FlutterResult,
        messenger: FlutterBinaryMessenger
    ) {
        do {
            let originalName = fileUrl.lastPathComponent

            let filePath = try copyFileToCache(
                fileUrl: fileUrl,
                fileName: originalName
            )

            let fileType = determineFileType(
                url: fileUrl
            )

            let fileHandlerChannel = FlutterMethodChannel(
                name: FILE_HANDLE_CHANNEL,
                binaryMessenger: messenger
            )

            fileHandlerChannel.invokeMethod(
                "onFileOpened",
                arguments: [
                    "path": filePath,
                    "type": fileType,
                    "originalName": originalName
                ]
            )

            result(filePath)

        } catch {
            result(
                FlutterError(
                    code: "FILE_ERROR",
                    message: "Error processing file: \(error.localizedDescription)",
                    details: nil
                )
            )
        }
    }

    private func copyFileToCache(
        fileUrl: URL,
        fileName: String
    ) throws -> String {
        let cacheDir = FileManager.default
            .urls(
                for: .cachesDirectory,
                in: .userDomainMask
            )
            .first!

        let destinationUrl = cacheDir
            .appendingPathComponent(fileName)

        if FileManager.default.fileExists(
            atPath: destinationUrl.path
        ) {
            try FileManager.default.removeItem(
                at: destinationUrl
            )
        }

        try FileManager.default.copyItem(
            at: fileUrl,
            to: destinationUrl
        )

        return destinationUrl.path
    }
}

extension AppDelegate: UIDocumentPickerDelegate {

    public func documentPicker(
        _ controller: UIDocumentPickerViewController,
        didPickDocumentsAt urls: [URL]
    ) {
        guard let url = urls.first else {
            result?(
                FlutterError(
                    code: "NO_FILE",
                    message: "No file selected",
                    details: nil
                )
            )

            result = nil
            return
        }

        guard url.startAccessingSecurityScopedResource() else {
            result?(
                FlutterError(
                    code: "ACCESS_DENIED",
                    message: "Could not access file",
                    details: nil
                )
            )

            result = nil
            return
        }

        defer {
            url.stopAccessingSecurityScopedResource()
        }

        do {
            let filePath = try copyFileToCache(
                fileUrl: url,
                fileName: url.lastPathComponent
            )

            result?(filePath)

        } catch {
            result?(
                FlutterError(
                    code: "COPY_FAILED",
                    message: "Failed to copy file: \(error.localizedDescription)",
                    details: nil
                )
            )
        }

        result = nil
    }

    public func documentPickerWasCancelled(
        _ controller: UIDocumentPickerViewController
    ) {
        result?(
            FlutterError(
                code: "CANCELLED",
                message: "File picking cancelled",
                details: nil
            )
        )

        result = nil
    }

    func storeOpenedFile(_ url: URL) {
        pendingFileUrl = url
    }
}