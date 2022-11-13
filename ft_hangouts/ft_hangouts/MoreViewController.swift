//
//  MoreViewController.swift
//  ft_hangouts
//
//  Created by Dmitry Novikov on 12.11.2022.
//

import UIKit

class MoreViewController: UIViewController {

	let defaults = UserDefaults.standard

	@IBOutlet weak var selectColorView: UIColorWell!
	@IBOutlet weak var exampleView: UITextView!

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let rgba: [CGFloat] = defaults.object(forKey: "headerColorRGBA") as? [CGFloat] ?? [0, 0, 0, 1]
		let color = UIColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])

		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: color]
		selectColorView.selectedColor = color
		exampleView.textColor = color
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		selectColorView.addTarget(self, action: #selector(colorChanged(_:)), for: .valueChanged)
	}

	@objc func colorChanged(_ sender: Any) {
		exampleView.textColor = selectColorView.selectedColor

		let headerColor: CIColor = CIColor(color: selectColorView.selectedColor ?? .black)
		let rgba: [CGFloat] = [headerColor.red, headerColor.green, headerColor.blue, headerColor.alpha]
		defaults.set(rgba, forKey: "headerColorRGBA")
	}

}
