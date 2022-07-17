//
//  Tasks+CoreDataProperties.swift
//  TodoList-coreData
//
//  Created by Akel Barbosa on 17/07/22.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var done: Bool
    @NSManaged public var name: String?
    @NSManaged public var activity: Activities?

}

extension Tasks : Identifiable {

}
