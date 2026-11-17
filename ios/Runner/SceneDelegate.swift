import UIKit
import Flutter

class SceneDelegate: FlutterSceneDelegate {

    override func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        guard let urlContext = URLContexts.first else {
            return
        }

        let url = urlContext.url

        super.scene(
            scene,
            openURLContexts: URLContexts
        )

        if let appDelegate = UIApplication.shared.delegate
            as? AppDelegate {

            appDelegate.storeOpenedFile(url)
        }
    }
}