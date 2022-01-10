//
//  MovieGroup+CoreDataProperties.swift
//  Umba
//
//  Created by CWG Mobile Dev on 07/01/2022.
//
//

import Foundation
import CoreData


extension MovieGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieGroup> {
        return NSFetchRequest<MovieGroup>(entityName: "MovieGroup")
    }

    @NSManaged public var name: String?
    @NSManaged public var group: NSSet?

}

// MARK: Generated accessors for group
extension MovieGroup {

    @objc(addGroupObject:)
    @NSManaged public func addToGroup(_ value: MovieEntity)

    @objc(removeGroupObject:)
    @NSManaged public func removeFromGroup(_ value: MovieEntity)

    @objc(addGroup:)
    @NSManaged public func addToGroup(_ values: NSSet)

    @objc(removeGroup:)
    @NSManaged public func removeFromGroup(_ values: NSSet)

}

extension MovieGroup : Identifiable {

}
