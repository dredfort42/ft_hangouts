//
//  ContactEditViewController.swift
//  ft_hangouts
//
//  Created by Dmitry Novikov on 09.11.2022.
//

import UIKit
import CoreData

class ContactEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

	var contactID: UUID?
	var contact: ContactData?

	@IBAction func cancelBarButtonAction(_ sender: UIBarButtonItem) {
		performSegue(withIdentifier: "toContacts", sender: self)
	}

	@IBAction func doneBarButtonAction(_ sender: UIBarButtonItem) {
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
		let managedContext = appDelegate.persistentContainer.viewContext

		if contactNameFieldView.hasText || phoneNumberFieldView.hasText {
			if contactID == nil {
				guard let entity = NSEntityDescription.entity(forEntityName: "ContactData", in: managedContext) else { return }
				let newContact = ContactData(entity: entity, insertInto: managedContext)
				if contactNameFieldView.hasText  {
					newContact.name = contactNameFieldView.text
				} else if phoneNumberFieldView.hasText {
					newContact.name = phoneNumberFieldView.text
				}
				newContact.phoneNumber = Int64(phoneNumberFieldView.text!) ?? 0
				newContact.image = (imageView.image?.jpegData(compressionQuality: 1.0))! as Data
				newContact.contactID = UUID()
			} else {
				contact!.name = contactNameFieldView.text
				contact!.phoneNumber = Int64(phoneNumberFieldView.text!) ?? 0
				contact!.image = (imageView.image?.jpegData(compressionQuality: 1.0))! as Data
			}

			do {
				try managedContext.save()
			} catch let error as NSError {
				print(error.localizedDescription)
			}
		}

		performSegue(withIdentifier: "toContacts", sender: self)
	}

	@IBAction func takePictureButtonAction(_ sender: UIButton) {
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			let imagePickerController = UIImagePickerController()
			imagePickerController.delegate = self
			imagePickerController.sourceType = .camera
			imagePickerController.allowsEditing = false
			self.present(imagePickerController, animated: true, completion: nil)
		}
	}

	@IBAction func choosePictureButtonAction(_ sender: UIButton) {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let imagePickerController = UIImagePickerController()
			imagePickerController.delegate = self
			imagePickerController.sourceType = .photoLibrary
			imagePickerController.allowsEditing = false
			self.present(imagePickerController, animated: true, completion: nil)
		}
	}

	@IBOutlet var spacerLabelView: [UILabel]!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet var imageButtonView: [UIButton]!
	@IBOutlet weak var contactNameFieldView: UITextField!
	@IBOutlet weak var phoneNumberFieldView: UITextField!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		contactNameFieldView.delegate = self
		for spacer in spacerLabelView {
			spacer.textColor = .white.withAlphaComponent(0)
		}

		imageView.layer.borderWidth = 1
		imageView.layer.borderColor = UIColor.lightGray.cgColor
		imageView.layer.cornerRadius = self.imageView.frame.width / 2

		for button in imageButtonView {
			button.layer.cornerRadius = button.frame.width / 2
			button.clipsToBounds = true
			button.layer.masksToBounds = true
		}


		if contactID != nil {
			guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
			let managedContext = appDelegate.persistentContainer.viewContext
			let fetchRequest = ContactData.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "contactID == %@", contactID! as CVarArg)

			do {
				contact = try (managedContext.fetch(fetchRequest))[0]
				if contact!.image != nil {
					imageView.image = UIImage(data: (contact!.image)! as Data )
				}
				contactNameFieldView.text = contact?.name
				phoneNumberFieldView.text = String(contact!.phoneNumber)
			} catch let error as NSError {
				print(error.localizedDescription)
			}
		}
	}

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		imageView.image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
		self.dismiss(animated: true, completion: nil)
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		if touches.first != nil {
			view.endEditing(true)
		}
		super.touchesBegan(touches, with: event)
	}

}
