//
//  ContactEditViewController.swift
//  ft_hangouts
//
//  Created by Dmitry Novikov on 09.11.2022.
//

import UIKit
import CoreData

class ContactEditViewController: UIViewController {


	@IBAction func cancelBarButtonAction(_ sender: UIBarButtonItem) {
		performSegue(withIdentifier: "toContacts", sender: self)
	}

	@IBAction func doneBarButtonAction(_ sender: UIBarButtonItem) {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		let context = appDelegate.persistentContainer.viewContext
		guard let contact = NSEntityDescription.entity(forEntityName: "ContactData", in: context) else { return }
		let contactDataObject = ContactData(entity: contact, insertInto: context)

		contactDataObject.contactID = UUID()
		if contactNameFieldView.hasText  {
			contactDataObject.name = contactNameFieldView.text
		} else if phoneNumberFieldView.hasText {
			contactDataObject.name = phoneNumberFieldView.text
		}
		if phoneNumberFieldView.hasText {
			contactDataObject.phoneNumber = Int64(phoneNumberFieldView.text!) ?? 0
		} else {
			contactDataObject.phoneNumber = 0
		}
		contactDataObject.image = nil

		do {
			try context.save()
		} catch let error as NSError {
			print(error.localizedDescription)
		}


		performSegue(withIdentifier: "toContacts", sender: self)
	}

	//	@IBAction func saveButtonAction(_ sender: UIButton) {
	//		let appDelegate = UIApplication.shared.delegate as! AppDelegate
	//		let context = appDelegate.persistentContainer.viewContext
	//		guard let contact = NSEntityDescription.entity(forEntityName: "ContactData", in: context) else { return }
	//		let contactDataObject = ContactData(entity: contact, insertInto: context)
	//
	//		contactDataObject.contactID = UUID()
	//		if contactNameFieldView.hasText  {
	//			contactDataObject.name = contactNameFieldView.text
	//		} else if phoneNumberFieldView.hasText {
	//			contactDataObject.name = phoneNumberFieldView.text
	//		}
	//		if phoneNumberFieldView.hasText {
	//			contactDataObject.phoneNumber = Int64(phoneNumberFieldView.text!) ?? 0
	//		} else {
	//			contactDataObject.phoneNumber = 0
	//		}
	//		contactDataObject.image = nil
	//
	//		do {
	//			try context.save()
	//		} catch let error as NSError {
	//			print(error.localizedDescription)
	//		}
	//
	//
	//		performSegue(withIdentifier: "toContacts", sender: self)
	//	}
	//
	//	@IBAction func cancelButtonAction(_ sender: UIButton) {
	//		performSegue(withIdentifier: "toContacts", sender: self)
	//	}


	@IBOutlet weak var contactNameFieldView: UITextField!
	@IBOutlet weak var phoneNumberFieldView: UITextField!


	//	func addNewContact(_ dataToSave: ContactData) {
	//		let appDelegate = UIApplication.shared.delegate as! AppDelegate
	//		let context = appDelegate.persistentContainer.viewContext
	//		guard let contact = NSEntityDescription.entity(forEntityName: "ContactData", in: context) else { return }
	//		let contactDataObject = ContactData(entity: contact, insertInto: context)
	//
	//		contactDataObject.name = dataToSave.name
	//		contactDataObject.phoneNumber = dataToSave.phoneNumber
	//		contactDataObject.image = dataToSave.image
	//
	//		do {
	//			try context.save()
	//		} catch let error as NSError {
	//			print(error.localizedDescription)
	//		}
	//	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}


	/*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	 // Get the new view controller using segue.destination.
	 // Pass the selected object to the new view controller.
	 }
	 */

}
