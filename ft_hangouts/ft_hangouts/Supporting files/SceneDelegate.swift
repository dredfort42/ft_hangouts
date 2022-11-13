//
//  SceneDelegate.swift
//  ft_hangouts
//
//  Created by Dmitry Novikov on 07.11.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

	var window: UIWindow?
	var setBackgroundTime: Date?


	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		// Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
		// If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
		// This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
		guard let _ = (scene as? UIWindowScene) else { return }
	}

	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
	}

	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}

	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).

		setBackgroundTime = Date()
	}

	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.

		if setBackgroundTime != nil {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "H:mm:ss"
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
				self.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
				let alertTitle = NSLocalizedString("IN_BACKGROUND", comment: "In the background from:")
				let alert = UIAlertController(
					title: alertTitle,
					message: dateFormatter.string(from: self.setBackgroundTime!),
					preferredStyle: .alert)
				let actionTitle = NSLocalizedString("OK_BUTTON", comment: "OK")
				let okAction = UIAlertAction(title: actionTitle, style: .default)
				alert.addAction(okAction)
				self.window?.rootViewController?.present(alert, animated: true, completion: nil)
				self.setBackgroundTime = nil
			}
		}
	}

	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
		// to restore the scene back to its current state.

		// Save changes in the application's managed object context when the application transitions to the background.
		(UIApplication.shared.delegate as? AppDelegate)?.saveContext()
	}

//	// MARK: - Set Background time
//
////	var setBackgroundTime: Date?
//
//
//
//	func applicationWillResignActive(_ application: UIApplication) {
////		setBackgroundTime = Date()
////		print(setBackgroundTime?.description)
//		print(#function)
//	}
//
//	func applicationDidEnterBackground(_ application: UIApplication) {
////		setBackgroundTime = Date()
////		print(setBackgroundTime?.description)
//		print(#function)
//	}
////
////	func applicationDidBecomeActive(_ application: UIApplication) {
////		if setBackgroundTime != nil {
//////			let alert = UIAlertController(
//////				title: "Returning time", message: setBackgroundTime?.description,         preferredStyle: UIAlertController.Style.alert)
//////
//////			alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in	}))
//////
//////			alert.present(alert, animated: true, completion: nil)
////			print(setBackgroundTime?.description)
////			setBackgroundTime = nil
////		}
////	}

}

