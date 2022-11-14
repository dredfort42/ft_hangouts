//
//  ContactEditViewController.swift
//  ft_hangouts
//
//  Created by Dmitry Novikov on 09.11.2022.
//

import UIKit
import CoreData
import ContactsUI

class ContactEditViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CNContactViewControllerDelegate {

	var contactID: UUID?
	var contact: ContactData?
	let store = CNContactStore()
	var contactName: String = ""

	@IBAction func cancelBarButtonAction(_ sender: UIBarButtonItem) {
		navigationController?.popToRootViewController(animated: true)
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
				if phoneNumberFieldView.text?.first == "+" {
					newContact.phoneNumber = phoneNumberFieldView.text ?? ""
				} else {
					newContact.phoneNumber = "+\(phoneNumberFieldView.text ?? "")"
				}
				newContact.image = (imageView.image?.jpegData(compressionQuality: 1.0))! as Data
				newContact.contactID = createContact()
			} else {
				contact!.name = contactNameFieldView.text
				if phoneNumberFieldView.text?.first == "+" {
					contact!.phoneNumber = phoneNumberFieldView.text ?? ""
				} else {
					contact!.phoneNumber = "+\(phoneNumberFieldView.text ?? "")"
				}
				contact!.image = (imageView.image?.jpegData(compressionQuality: 1.0))! as Data
				updateContact(name: contactName)
				contactName = ""
			}

			do {
				try managedContext.save()
			} catch let error as NSError {
				print(error.localizedDescription)
			}
		}
		navigationController?.popToRootViewController(animated: true)
	}

	func createContact() -> UUID {

		let mutableContact = CNMutableContact()
		mutableContact.imageData = (imageView.image?.jpegData(compressionQuality: 1.0))! as Data
		mutableContact.givenName = contactNameFieldView.text ?? ""
		if phoneNumberFieldView.text?.first == "+" {
			mutableContact.phoneNumbers.append(CNLabeledValue(
				label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: (phoneNumberFieldView.text ?? ""))))
		} else {
			mutableContact.phoneNumbers.append(CNLabeledValue(
				label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: ("+" + (phoneNumberFieldView.text ?? "")))))
		}

		let saveRequest = CNSaveRequest()
		saveRequest.add(mutableContact, toContainerWithIdentifier: nil)
		do {
			try store.execute(saveRequest)
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		return mutableContact.id
	}

	func updateContact(name: String) {
		do {
			let predicate = CNContact.predicateForContacts(matchingName: name)
			let cnContacts = try store.unifiedContacts(matching: predicate, keysToFetch: [
				CNContactImageDataKey as CNKeyDescriptor,
				CNContactGivenNameKey as CNKeyDescriptor,
				CNContactPhoneNumbersKey as CNKeyDescriptor,
			])
			guard let cnContact = cnContacts.first else {
				print("Contact not found")
				return
			}
			print(cnContact)
			guard let mutableContact = cnContact.mutableCopy() as? CNMutableContact else { return }
			mutableContact.imageData = (imageView.image?.jpegData(compressionQuality: 1.0))! as Data
			mutableContact.givenName = contactNameFieldView.text ?? ""
			if phoneNumberFieldView.text?.first == "+" {
				mutableContact.phoneNumbers[0] = CNLabeledValue(
					label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: (phoneNumberFieldView.text ?? "")))
			} else {
				mutableContact.phoneNumbers[0] = CNLabeledValue(
					label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: ("+" + (phoneNumberFieldView.text ?? ""))))
			}

			let saveRequest = CNSaveRequest()
			saveRequest.update(mutableContact)
			try store.execute(saveRequest)

		} catch let error as NSError {
			print(error.localizedDescription)
		}
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

	@IBAction func erasePictureButtonAction(_ sender: UIButton) {
		imageView.image = UIImage(named: "Invader")
	}

	@IBOutlet var spacerLabelView: [UILabel]!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet var imageButtonView: [UIButton]!
	@IBOutlet weak var contactNameFieldView: UITextField!
	@IBOutlet weak var phoneNumberFieldView: UITextField!

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
				contactName = contact?.name ?? ""
				phoneNumberFieldView.text = contact?.phoneNumber
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
