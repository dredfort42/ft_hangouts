//
//  ContactData+CoreDataProperties.swift
//  ft_hangouts
//
//  Created by Dmitry Novikov on 08.11.2022.
//
//

import Foundation
import CoreData


extension ContactData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactData> {
        return NSFetchRequest<ContactData>(entityName: "ContactData")
    }

    @NSManaged public var name: String?
    @NSManaged public var phoneNumber: Int64
    @NSManaged public var image: Data?
	@NSManaged public var contactID: UUID

}

extension ContactData : Identifiable {

}
