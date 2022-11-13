//
//  ContactsTableViewController.swift
//  ft_hangouts
//
//  Created by Dmitry Novikov on 08.11.2022.
//

import UIKit
import CoreData

class ContactsTableViewController: UITableViewController {

	let defaults = UserDefaults.standard
	var contacts: [ContactData] = []
	var groups: [String] = []

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		contacts.removeAll()
		contacts = getContacts()

		groups.removeAll()
		for contact in contacts {
			if !groups.contains(contact.name?.first?.uppercased() ?? "ERROR") {
				print(contact.name?.first?.uppercased() ?? "ERROR")
				groups.append(contact.name?.first?.uppercased() ?? "ERROR")
			}
		}
		groups.sort(by: {$0 < $1})
		print(groups)

		tableView.reloadData()

		let rgba: [CGFloat] = defaults.object(forKey: "headerColorRGBA") as? [CGFloat] ?? [0, 0, 0, 0]

		navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: rgba[0], green: rgba[1], blue: rgba[2], alpha: rgba[3])]

//		if SceneDelegate.setBackgroundTime != nil {
//
//			present(alert, animated: true)
//			SceneDelegate.setBackgroundTime = nil
//		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
	}

	// MARK: - Table view data source

	override func numberOfSections(in tableView: UITableView) -> Int {
		// #warning Incomplete implementation, return the number of sections
		return groups.count
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return groups[section]
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		// #warning Incomplete implementation, return the number of rows
		var rows = 0
		let sectionLetter = groups[section]

		for contact in contacts {
			if (contact.name?.first?.uppercased() ?? "ERROR") == sectionLetter {
				rows += 1
			}
		}

		return rows
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)

		var rowNum = 0
		for contact in contacts {
			if groups[indexPath.section] != (contact.name?.first?.uppercased() ?? "ERROR") {
				rowNum += 1
			} else {
				break
			}
		}

		cell.textLabel?.text = contacts[rowNum + indexPath.row].name

		return cell
	}

	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		return groups
	}

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "clickOnContact" {
			if let indexPath = tableView.indexPathForSelectedRow {
				let destinationView = segue.destination as! SummaryViewController

				var rowNum = 0
				for contact in contacts {
					if groups[indexPath.section] != (contact.name?.first?.uppercased() ?? "ERROR") {
						rowNum += 1
					} else {
						break
					}
				}
				destinationView.contact = contacts[rowNum + indexPath.row]
			}
		}
	}

	func getContacts() -> [ContactData] {
		var tmpContats: [ContactData] = []
		guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return tmpContats }
		let managedContext = appDelegate.persistentContainer.viewContext
		let fetchRequest = ContactData.fetchRequest()

		do {
			tmpContats = try (managedContext.fetch(fetchRequest))
		} catch let error as NSError {
			print(error.localizedDescription)
		}
		tmpContats.sort(by: { $0.name ?? "" < $1.name ?? "" })
		return tmpContats
	}

}
