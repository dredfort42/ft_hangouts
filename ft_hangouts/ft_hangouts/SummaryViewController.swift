//
//  SummaryViewController.swift
//  ft_hangouts
//
//  Created by Dmitry Novikov on 10.11.2022.
//

import UIKit
import MessageUI
import ContactsUI

class SummaryViewController: UIViewController, MFMessageComposeViewControllerDelegate, CNContactViewControllerDelegate {

	var contact: ContactData?
	let store = CNContactStore()

	@IBOutlet var spacerLabelView: [UILabel]!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var contactLabelView: UILabel!
	@IBOutlet weak var phoneNumberLabelView: UILabel!

	@IBAction func sendMessageButtonAction(_ sender: UIButton) {
		if MFMessageComposeViewController.canSendText() && phoneNumberLabelView.text != nil {
			let messageController = MFMessageComposeViewController()
			messageController.body = ""
			messageController.recipients = ["+\(phoneNumberLabelView.text ?? "no number")"]
			messageController.messageComposeDelegate = self
			self.present(messageController, animated: true)
		}
	}

	func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
		switch (result) {
					case .cancelled:
						print("Message was cancelled")
						dismiss(animated: true, completion: nil)
					case .failed:
						print("Message failed")
						dismiss(animated: true, completion: nil)
					case .sent:
						print("Message was sent")
						dismiss(animated: true, completion: nil)
					default:
						break
				}
	}

	@IBAction func callButtonAction(_ sender: UIButton) {
		if phoneNumberLabelView.text != nil {
			if let url = URL(string: "tel://" + phoneNumberLabelView.text!) {
				if UIApplication.shared.canOpenURL(url) {
					UIApplication.shared.open(url, options: [:], completionHandler: nil)
				}
			}
		}
		print("Call to \(phoneNumberLabelView.text!)")
	}

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

		do {
			let predicate = CNContact.predicateForContacts(matchingName: contactLabelView.text ?? "")
			let cnContacts = try store.unifiedContacts(matching: predicate, keysToFetch: [
				CNContactImageDataKey as CNKeyDescriptor,
				CNContactGivenNameKey as CNKeyDescriptor,
				CNContactPhoneNumbersKey as CNKeyDescriptor,
			])
			guard let cnContact = cnContacts.first else {
				print("Contact not found")
				return
			}
			guard let mutableContact = cnContact.mutableCopy() as? CNMutableContact else { return }
			let saveRequest = CNSaveRequest()
			saveRequest.delete(mutableContact)
			try store.execute(saveRequest)

		} catch let error as NSError {
			print(error.localizedDescription)
		}

		navigationController?.popToRootViewController(animated: true)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		let defaults = UserDefaults.standard
		let rgba: [CGFloat] = defaults.object(forKey: "headerColorRGBA") as? [CGFloat] ?? [0, 0, 0, 0]
		let color = UIColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])

		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: color]
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
		phoneNumberLabelView.text = summary.phoneNumber
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if  segue.identifier == "editContact" {
			let destinationView = segue.destination as! ContactEditViewController
			destinationView.contactID = contact?.contactID
		}
	}

}
