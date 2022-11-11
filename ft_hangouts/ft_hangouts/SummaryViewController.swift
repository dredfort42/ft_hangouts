//
//  SummaryViewController.swift
//  ft_hangouts
//
//  Created by Dmitry Novikov on 10.11.2022.
//

import UIKit

class SummaryViewController: UIViewController {

	var contact: ContactData?


	@IBOutlet var spacerLabelView: [UILabel]!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var contactLabelView: UILabel!
	@IBOutlet weak var phoneNumberLabelView: UILabel!

	@IBAction func deleteContactButtonAction(_ sender: UIButton) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext


		if contact != nil {
			context.delete(contact!)
		}
		do {
			try context.save()
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		performSegue(withIdentifier: "toContacts", sender: self)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		for spacer in spacerLabelView {
			spacer.textColor = .white.withAlphaComponent(0)
		}
		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.lightGray.cgColor
		imageView.layer.cornerRadius = self.imageView.frame.width / 2

		guard let summary = contact else { return }
		if summary.image != nil {
			imageView.image = UIImage(data: summary.image! as Data )
		}
		contactLabelView.text = summary.name
		phoneNumberLabelView.text = String(summary.phoneNumber)
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if  segue.identifier == "editContact" {
			let destinationView = segue.destination as! ContactEditViewController
			destinationView.contactID = contact?.contactID
		}
	}

}
