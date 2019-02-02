//
//  ListItem+CoreDataProperties.swift
//  PalmList
//
//  Created by Timothy Waters on 2/2/19.
//  Copyright © 2019 Timmy Waters Software. All rights reserved.
//
//

import Foundation
import CoreData


extension ListItem {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<ListItem> {
        return NSFetchRequest<ListItem>(entityName: "ListItem")
    }

    @NSManaged public var isChecked: Bool
    @NSManaged public var priorityLevel: Int16
    @NSManaged public var itemText: String

}
