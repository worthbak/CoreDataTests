//
//  Person+CoreDataProperties.swift
//  CDTests
//
//  Created by David Baker on 12/21/15.
//  Copyright © 2015 Worth Baker. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Person {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var dateCreated: NSDate?

}
